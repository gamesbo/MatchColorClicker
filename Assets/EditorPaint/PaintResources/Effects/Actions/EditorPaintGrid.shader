// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Copyright 2018 Prized Goat
// Prized Goat is a small indie group of friends, if this file was obtained without purchase,
// please support our efforts by purchasing a copy from the Unity Asset Store.  Thanks

Shader "Hidden/EditorPaint/Grid" 
{
	Properties
	{
		horzGrid("Horz Grid", Range(0,256)) = 10
		vertGrid("Vert Grid", Range(0,256)) = 10
		horzGridOffset("Horz Offset", Range(0,1)) = 0.5
		vertGridOffset("Vert Offset", Range(0,1)) = 0.5
		horzSize("Horz Size", Range(0,1)) = 0.1
		vertSize("Vert Size", Range(0,1)) = 0.1
		color1("Color 1", Color) = (1,1,1,1)
		color2("Color 2", Color) = (0,0,0,1)
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
			float horzGrid;
			float vertGrid;
			float horzGridOffset;
			float vertGridOffset;
			float horzSize;
			float vertSize;
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

				float linesX = 1;
				float linesY = 1;
				float gridX = frac((i.uv.x + (horzGridOffset / horzGrid)) * horzGrid);
				float gridY = frac((i.uv.y + (vertGridOffset / vertGrid)) * vertGrid);

				if (gridX > horzSize)
				{
					linesX = 0;
				}
				if (gridY > vertSize)
				{
					linesY = 0;
				}

				color = lerp(color1, color2, saturate(linesX + linesY));

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
