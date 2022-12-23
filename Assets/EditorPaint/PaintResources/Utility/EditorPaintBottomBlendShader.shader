// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Copyright 2018 Prized Goat
// Prized Goat is a small indie group of friends, if this file was obtained without purchase,
// please support our efforts by purchasing a copy from the Unity Asset Store.  Thanks

Shader "Hidden/EditorPaint/Composite/BottomBlend" 
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
				float2 uv0 : TEXCOORD0;
				float2 uv1 : TEXCOORD1;
			};

			sampler2D _BackgroundTex;

			float _TileRate;
			float2 _Rez;
			sampler2D _LayerTex;
			sampler2D _BlendALphaTex;
						
			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv0 = v.texcoord;
				float2 uvMod = _Rez;
				uvMod *= _TileRate;
				o.uv1 = v.texcoord * uvMod;
				return o;
			}

			float4 frag (v2f i) : SV_Target
			{
				float4 output = tex2D(_BackgroundTex, i.uv1);
				float4 layerTex = tex2D(_LayerTex, i.uv0);
				float alphaTex = tex2D(_BlendALphaTex, i.uv0).r;

				output = lerp(output, layerTex, alphaTex);
				output.a = 1;

				return  output;
			}
			ENDCG 
		}
	} 
	
	Fallback off 
}
