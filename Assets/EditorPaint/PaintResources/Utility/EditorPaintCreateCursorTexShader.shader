// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Copyright 2018 Prized Goat
// Prized Goat is a small indie group of friends, if this file was obtained without purchase,
// please support our efforts by purchasing a copy from the Unity Asset Store.  Thanks

Shader "Hidden/EditorPaint/CreateCursorTexShader"
{
	Properties
		{
		}
	SubShader {
	Pass{
		CGPROGRAM
		#pragma target 3.0
		#pragma vertex vert
		#pragma fragment frag

		sampler2D _Brush;
		float _Resolution;
		float _Size;

		static int range = 5;
		static int startValue = 0;
		float accumulation = 0;

			struct appdata
			{
				float4 vertex : POSITION;
				float4 texcoord : TEXCOORD0;
			};

			struct v2f
			{
				float4 pos : POSITION;
				float2 uv : TEXCOORD0;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos( v.vertex );
				o.uv = v.texcoord.xy;
				return o;
			}

			float random(float2 p)
			{
				// We use irrationals for pseudo randomness.
				// Most known transcendental numbers should work.
				const float2 r = float2(
					23.1406926327792690,  // e^pi (Gelfond's constant)
					2.6651441426902251); // 2^sqrt(2) (Gelfond–Schneider constant)
				return saturate(frac(cos(fmod(123456789., 1e-7 + 256. * dot(p, r)))));
			}

			float4 frag(v2f i) : COLOR
			{				
				float pixelSize = 1.0f / _Resolution;
				pixelSize *= (1.0f / _Size);
				float2 cacheUV = i.uv;
				
				float centerPixel = 1.0f - tex2D(_Brush, i.uv).r;
				centerPixel -= 0.1f;
				centerPixel *= 10;
				centerPixel = saturate(centerPixel);
				centerPixel = ceil(centerPixel);
				
				for (int i = startValue; i < range; i++)
				{
					for (int j = startValue; j < range; j++)
					{
						float2 offset = float2(cacheUV.x + ((i - 2) * pixelSize), cacheUV.y + ((j - 2) * pixelSize));
						float2 tempuv = clamp(offset, 0, 1);
						float pixel = 1.0f - tex2D(_Brush, tempuv).r;
						pixel -= 0.1f;
						pixel *= 100;
						pixel = clamp(pixel, 0, 1);

						accumulation = accumulation + pixel;
					}
				}
				
				accumulation = accumulation / (range * range);
				
				float4 output = (random(cacheUV) * 0.75f) + 0.125f;
				output.a = 0.7f;
				if (accumulation == centerPixel)
				{
					output.a = 0.0f;
				}		
				
				// Set the outside edge pixels to white so they bleed correctly
				if (cacheUV.x <= (pixelSize) || cacheUV.x >= (1.0f - pixelSize) || cacheUV.y <= (pixelSize) || cacheUV.y >= (1.0f - pixelSize))
				{
					output.a = 0.0f;
				}
				
				return output;
			}
		ENDCG
		}
	}
}