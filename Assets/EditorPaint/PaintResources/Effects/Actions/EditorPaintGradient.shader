// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Copyright 2018 Prized Goat
// Prized Goat is a small indie group of friends, if this file was obtained without purchase,
// please support our efforts by purchasing a copy from the Unity Asset Store.  Thanks

Shader "Hidden/EditorPaint/Gradient" 
{
	Properties
	{
		horzGrad("Horz Grad", Range(-1,1)) = 1
		vertGrad("Vert Grad", Range(-1,1)) = 0
		color1("Color 1", Color) = (0,0,1,1)
		color2("Color 2", Color) = (0,1,0,1)
		gradInt("Intensity", Range(0,2)) = 1
		circleGradient("Use Circle", Range(0,1)) = 0
		circlePow("Circle Pow", Range(0,1)) = 1
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
				float2 uv : TEXCOORD0;
			};

			sampler2D _MainTex;
			sampler2D _BlendAlphaTex;
			float horzGrad;
			float vertGrad;
			float gradInt;
			float circleGradient;
			float circlePow;
			float4 color1;
			float4 color2;
			// This value is checked by the script to decide if it should apply the shader to both the active and inactive texture
			int ApplyToInactiveTexture;
			
			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.texcoord;
				return o;
			}

			float4 frag (v2f i) : SV_Target
			{
				float4 color = tex2D(_MainTex, i.uv);
				float alpha = tex2D(_BlendAlphaTex, i.uv);
				color /= alpha;

				if (circleGradient < 1)
				{
					float uv1 = i.uv.x * horzGrad;
					float uv2 = i.uv.y * vertGrad;
					if (horzGrad < 0)
					{
						uv1 = (1.0f - i.uv.x) * abs(horzGrad);
					}
					if (vertGrad < 0)
					{
						uv2 = (1.0f - i.uv.y) * abs(vertGrad);
					}

					color = lerp(color1, color2, (uv1 + uv2) * gradInt);
				}
				else
				{
					float gradient = length(0.5f - i.uv) * 2;
					circlePow = pow(circlePow, 5) * 100;
					color = lerp(color1, color2, pow(gradient * gradInt, circlePow));
				}

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
				float2 uv : TEXCOORD0;
			};

			sampler2D _MainTex;
			sampler2D _BlendAlphaTex;

			v2f vert(appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.texcoord;
				return o;
			}

			float4 frag(v2f i) : SV_Target
			{
				float4 color = tex2D(_BlendAlphaTex, i.uv);
				color.a = 1;

				return color;
			}
				ENDCG
			}
	} 
	
	Fallback off 
}
