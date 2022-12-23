// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Copyright 2018 Prized Goat
// Prized Goat is a small indie group of friends, if this file was obtained without purchase,
// please support our efforts by purchasing a copy from the Unity Asset Store.  Thanks

Shader "Hidden/EditorPaint/Levels" 
{
	Properties
	{
		inWhite("In White", Range(0.0, 1.0)) = 1
		inMid("In Mid", Range(0.0, 2.0)) = 1.0
		inBlack("In Black", Range(0.0, 1.0)) = 0
		outWhite("Out White", Range(0.0, 1.0)) = 1
		outBlack("Out Black", Range(0.0, 1.0)) = 0
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

			struct appdata_t {
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				float2 texcoord : TEXCOORD0;
			};

			sampler2D _MainTex;
			sampler2D _BlendAlphaTex;
			float inWhite;
			float inBlack;
			float inMid;
			float outWhite;
			float outBlack;
			// This value is checked by the script to decide if it should apply the shader to both the active and inactive texture
			int ApplyToInactiveTexture;
			
			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord = v.texcoord;
				return o;
			}

			float4 frag (v2f i) : SV_Target
			{
				float4 color = tex2D(_MainTex, i.texcoord);
				float alpha = tex2D(_BlendAlphaTex, i.texcoord);
				color /= alpha;

				float inGamma;
				if (inMid <= 1.0f)
				{
					inGamma = lerp(0.01f, 1.0f, inMid);  // Low range remapping
				}
				else
				{
					inGamma = lerp(1.0f, 9.99f, pow(inMid - 1, 2));  // High range remapping
				}

				inWhite = clamp(inWhite, 0.0001f, 0.9999f);
				inBlack = clamp(inBlack, 0.0001f, 0.9999f);

				// Levels math
				float3 outPixel = pow(saturate(color - inBlack) / clamp((inWhite - inBlack), 0.0001f, 1.0f), inGamma);
				outPixel *= outWhite;
				outPixel = 1.0f - ((1.0f - outPixel) * (1.0f - outBlack));

				color.rgb = saturate(outPixel);
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

				struct appdata_t {
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				float2 texcoord : TEXCOORD0;
			};

			sampler2D _MainTex;
			sampler2D _BlendAlphaTex;

			v2f vert(appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord = v.texcoord;
				return o;
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