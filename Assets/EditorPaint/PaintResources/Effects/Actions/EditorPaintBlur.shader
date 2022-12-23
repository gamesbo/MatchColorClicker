// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Copyright 2018 Prized Goat
// Prized Goat is a small indie group of friends, if this file was obtained without purchase,
// please support our efforts by purchasing a copy from the Unity Asset Store.  Thanks

Shader "Hidden/EditorPaint/Blur" 
{
	Properties
	{
		iterations("Blur", Range(2,64)) = 32
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
			float4 _MainTex_TexelSize;
			sampler2D _BlendAlphaTex;
			float4 _BlendAlphaTex_TexelSize;
			float iterations;    //should always be a even number
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
				float4 color = 0;
				float2 uv = i.texcoord;
				float rdx = _MainTex_TexelSize.x;
				float rdy = _MainTex_TexelSize.y;
				float2 centeredUV = uv + float2(rdx, rdy) * 0.5f;  // this centers the location in the pixel to avoid filtering errors

				int halfSize = iterations * 0.5f;
				float weight = 0;
				float sum = 0;
				int blur = 8;

				for (int i = -halfSize; i < halfSize; i++)
				{
					for (int j = -halfSize; j < halfSize; j++)
					{
						float2 offset = float2(i * rdx, j * rdy);
						float2 tempUV = centeredUV + offset;

						if (tempUV.x > rdx && tempUV.x < (1.0f - rdx) && tempUV.y > rdy && tempUV.y < (1.0f - rdy))
						{
							weight = (1.0f / (2.0f * 3.1415926f * blur * blur) * exp(-(i * i + j * j) / (2.0f * blur * blur)));
							color += tex2D(_MainTex, tempUV) * weight;
							sum += weight;
						}
					}
				}

				if (sum > 0)
				{
					color *= (1.0f / sum);
				}
				else
				{
					color = tex2D(_MainTex, uv);
				}
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
			float4 _MainTex_TexelSize;
			sampler2D _BlendAlphaTex;
			float4 _BlendAlphaTex_TexelSize;
			float iterations;    //should always be a even number

			v2f vert(appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord = v.texcoord;
				return o;
			}

			float4 frag(v2f i) : SV_Target
			{
				float4 color = 0;
				float2 uv = i.texcoord;
				float rdx = _BlendAlphaTex_TexelSize.x;
				float rdy = _BlendAlphaTex_TexelSize.y;
				float2 centeredUV = uv + float2(rdx, rdy) * 0.5f;  // this centers the location in the pixel to avoid filtering errors

				int halfSize = iterations * 0.5f;
				float weight = 0;
				float sum = 0;
				int blur = 8;

				for (int i = -halfSize; i < halfSize; i++)
				{
					for (int j = -halfSize; j < halfSize; j++)
					{
						float2 offset = float2(i * rdx, j * rdy);
						float2 tempUV = centeredUV + offset;

						if (tempUV.x > rdx && tempUV.x < (1.0f - rdx) && tempUV.y > rdy && tempUV.y < (1.0f - rdy))
						{
							weight = (1.0f / (2.0f * 3.1415926f * blur * blur) * exp(-(i * i + j * j) / (2.0f * blur * blur)));
							color += tex2D(_BlendAlphaTex, tempUV) * weight;
							sum += weight;
						}
					}
				}

				if (sum > 0)
				{
					color *= (1.0f / sum);
				}
				else
				{
					color = tex2D(_BlendAlphaTex, uv);
				}
				color.a = 1;

				return color;
			}
				ENDCG
			}
	} 
	
	Fallback off 
}
