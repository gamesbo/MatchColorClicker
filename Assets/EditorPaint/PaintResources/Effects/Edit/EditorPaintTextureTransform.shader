// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Copyright 2018 Prized Goat
// Prized Goat is a small indie group of friends, if this file was obtained without purchase,
// please support our efforts by purchasing a copy from the Unity Asset Store.  Thanks

Shader "Hidden/EditorPaint/Texture Transform" 
{
	Properties
	{
		Scale_X("Scale Horizontal", Range(0.01, 5.0)) = 1.0
		Scale_Y("Scale Vertical", Range(0.01, 5.0)) = 1.0
		Pos_X("Pos Horizontal", Range(-1.0, 1.0)) = 0.0
		Pos_Y("Pos Vertical", Range(-1.0, 1.0)) = 0.0
		Rotation("Rotation", Range(-180.0, 180.0)) = 0.0
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
			float Scale_X;
			float Scale_Y;
			float Pos_X;
			float Pos_Y;
			float Rotation;
			// This value is checked by the script to decide if it should apply the shader to both the active and inactive texture
			int ApplyToInactiveTexture;
			
			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				
				// Position
				v.texcoord.xy += float2(Pos_X, Pos_Y);

				// Rotation
				float rotation = Rotation / 57.2958f;
				float sinX = sin(rotation);
				float cosX = cos(rotation);
				float sinY = sin(rotation);
				float2x2 rotMatrix = float2x2(cosX, -sinX, sinY, cosX);
				o.texcoord = mul(v.texcoord.xy - 0.5f, rotMatrix) + 0.5f;

				// Scale
				o.texcoord = ((o.texcoord - 0.5f) * (1.0f / float2(Scale_X, Scale_Y))) + 0.5f;
				return o;
			}

			float4 frag (v2f i) : SV_Target
			{
				float4 color = tex2D(_MainTex, i.texcoord);
				if (i.texcoord.x < 0 || i.texcoord.x > 1 || i.texcoord.y < 0 || i.texcoord.y > 1)
				{
					color = 0;
				}
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
			float Scale_X;
			float Scale_Y;
			float Pos_X;
			float Pos_Y;
			float Rotation;

			v2f vert(appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);

				// Position
				v.texcoord.xy += float2(Pos_X, Pos_Y);

				// Rotation
				float rotation = Rotation / 57.2958f;
				float sinX = sin(rotation);
				float cosX = cos(rotation);
				float sinY = sin(rotation);
				float2x2 rotMatrix = float2x2(cosX, -sinX, sinY, cosX);
				o.texcoord = mul(v.texcoord.xy - 0.5f, rotMatrix) + 0.5f;

				// Scale
				o.texcoord = ((o.texcoord - 0.5f) * (1.0f / float2(Scale_X, Scale_Y))) + 0.5f;
				return o;
			}

			float4 frag(v2f i) : SV_Target
			{
				float4 color = tex2D(_BlendAlphaTex, i.texcoord);
				if (i.texcoord.x < 0 || i.texcoord.x > 1 || i.texcoord.y < 0 || i.texcoord.y > 1)
				{
					color = 0;
				}
				color.a = 1;

				return color;
			}
				ENDCG
			}
	} 
	
	Fallback off 
}
