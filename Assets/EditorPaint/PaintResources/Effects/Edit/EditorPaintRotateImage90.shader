// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Copyright 2018 Prized Goat
// Prized Goat is a small indie group of friends, if this file was obtained without purchase,
// please support our efforts by purchasing a copy from the Unity Asset Store.  Thanks

Shader "Hidden/EditorPaint/Rotate 90" 
{
	Properties
	{
		// This value is checked by the script to decide if it should apply the shader to both the active and inactive texture
		ApplyToInactiveTexture("ApplyToInactiveTexture", Range(0,1)) = 1
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
			// This value is checked by the script to decide if it should apply the shader to both the active and inactive texture
			int ApplyToInactiveTexture;
			
			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord = v.texcoord;
				//rotate 90 deg clockwise
				float2 uv;
				uv.x = 1.0f - o.texcoord.y;
				uv.y = o.texcoord.x;
				o.texcoord = uv;

				return o;
			}

			float4 frag (v2f i) : SV_Target
			{
				float4 color = tex2D(_MainTex, i.texcoord);
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
				//rotate 90 deg clockwise
				float2 uv;
				uv.x = 1.0f - o.texcoord.y;
				uv.y = o.texcoord.x;
				o.texcoord = uv;

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
