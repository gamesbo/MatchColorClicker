// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Copyright 2018 Prized Goat
// Prized Goat is a small indie group of friends, if this file was obtained without purchase,
// please support our efforts by purchasing a copy from the Unity Asset Store.  Thanks

Shader "Hidden/EditorPaint/Noise" 
{
	Properties
	{
		noiseIntensity("Intensity", Range(0.0, 1.0)) = 0.5
		// This value is checked by the script to decide if it should apply the shader to both the active and inactive texture
		ApplyToInactiveTexture("ApplyToInactiveTexture", Range(0,1)) = 0
	} 

	SubShader {

		Tags { "ForceSupported" = "True" "RenderType"="Overlay" } 
		
		Lighting Off 
		Blend SrcAlpha OneMinusSrcAlpha 
		Cull Off 
		ZWrite Off 
		ZTest Always 
		
		///====================
		/// Diffuse pass
		///====================
		Pass {	
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0

			struct appdata_t
			{
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 texcoord : TEXCOORD0;
			};

			sampler2D _MainTex;
			sampler2D _BlendAlphaTex;
			float noiseIntensity;
			// This value is checked by the script to decide if it should apply the shader to both the active and inactive texture
			int ApplyToInactiveTexture;
			
			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord = v.texcoord;
				return o;
			}

			float random(float2 p)
			{
				// We need irrationals for pseudo randomness.
				// Most (all?) known transcendental numbers will (mostly) work.
				const float2 r = float2(
					23.1406926327792690,  // e^pi (Gelfond's constant)
					2.6651441426902251); // 2^sqrt(2) (Gelfond?Schneider constant)
				return saturate(frac(cos(fmod(123456789., 1e-7 + 256. * dot(p, r)))));
			}

			float4 frag (v2f i) : SV_Target
			{
				float4 color = tex2D(_MainTex, i.texcoord);
				float alpha = tex2D(_BlendAlphaTex, i.texcoord);
				color /= alpha;

				float noise = ((random(i.texcoord + frac(_Time.x)) - 0.5f) * noiseIntensity * 2);
				noise = clamp(noise, -0.99f, 0.99f);
				color = saturate(color + noise);
				
				color *= alpha;
				color.a = 1;

				return color;
			}
			ENDCG 
		}

		///====================
		/// BlendAlpha pass
		///====================
		Pass{
				CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 3.0

				struct appdata_t
			{
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 texcoord : TEXCOORD0;
			};

			sampler2D _MainTex;
			sampler2D _BlendAlphaTex;
			float noiseIntensity;

			v2f vert(appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord = v.texcoord;
				return o;
			}

			float random(float2 p)
			{
				// We need irrationals for pseudo randomness.
				// Most (all?) known transcendental numbers will (mostly) work.
				const float2 r = float2(
					23.1406926327792690,  // e^pi (Gelfond's constant)
					2.6651441426902251); // 2^sqrt(2) (Gelfond?Schneider constant)
				return saturate(frac(cos(fmod(123456789., 1e-7 + 256. * dot(p, r)))));
			}

			float4 frag(v2f i) : SV_Target
			{
				float4 color = tex2D(_BlendAlphaTex, i.texcoord);
				color.a = 1;

				return color;
			}
				ENDCG
			}
	} 
	
	Fallback off 
}