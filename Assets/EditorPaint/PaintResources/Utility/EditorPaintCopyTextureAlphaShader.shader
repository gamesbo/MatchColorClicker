// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Copyright 2018 Prized Goat
// Prized Goat is a small indie group of friends, if this file was obtained without purchase,
// please support our efforts by purchasing a copy from the Unity Asset Store.  Thanks

Shader "Hidden/EditorPaint/Utility/CopyTextureAlpha" 
{
	Properties
	{
	}

	SubShader {

		Tags { "ForceSupported" = "True" "RenderType"="Overlay" } 
		
		Lighting Off 
		Blend SrcAlpha OneMinusSrcAlpha 
		Cull Off 
		ZWrite Off 
		ZTest Always 
		
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

			sampler2D SourceTexture;
			int HasAlpha;
			
			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord = v.texcoord;
				return o;
			}

			float4 frag (v2f i) : SV_Target
			{
				float4 color = tex2D(SourceTexture, i.texcoord);
				color.r = 1;
				color.g = 1;
				color.b = 1;
				if (HasAlpha)
				{
					color.r = color.a;
					color.g = color.a;
					color.b = color.a;
				}
				color.a = 1;
				return  color;
			}
			ENDCG 
		}
	} 
	
	Fallback off 
}
