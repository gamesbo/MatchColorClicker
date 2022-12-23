// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Copyright 2018 Prized Goat
// Prized Goat is a small indie group of friends, if this file was obtained without purchase,
// please support our efforts by purchasing a copy from the Unity Asset Store.  Thanks

Shader "Hidden/EditorPaint/Tile and Offset" 
{
	Properties
	{
		Tile_X("Tile Horizontal", Range(0.1, 20.0)) = 1.0
		Tile_Y("Tile Vertical", Range(0.1, 20.0)) = 1.0
		Offset_X("Offset Horizontal", Range(0.0, 1.0)) = 0.0
		Offset_Y("Offset Vertical", Range(0.0, 1.0)) = 0.0
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
		Pass
	{	
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
			float Tile_X;
			float Tile_Y;
			float Offset_X;
			float Offset_Y;
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
				Offset_X *= 1.0f / Tile_X;
				Offset_Y *= 1.0f / Tile_Y;

				float4 color = tex2D(_MainTex, frac((i.texcoord + float2(Offset_X, Offset_Y)) * float2(Tile_X, Tile_Y)));
				color.a = 1;

				return color;
			}
			ENDCG 
		}

		///====================
		/// BlendAlpha pass
		///====================
		Pass
			{
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
			float Tile_X;
			float Tile_Y;
			float Offset_X;
			float Offset_Y;

			v2f vert(appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord = v.texcoord;
				return o;
			}

			float4 frag(v2f i) : SV_Target
			{
				Offset_X *= 1.0f / Tile_X;
				Offset_Y *= 1.0f / Tile_Y;

				float4 color = tex2D(_BlendAlphaTex, frac((i.texcoord + float2(Offset_X, Offset_Y)) * float2(Tile_X, Tile_Y)));
				color.a = 1;

				return color;
			}
				ENDCG
			}
	} 
	
	Fallback off 
}
