// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Copyright 2018 Prized Goat
// Prized Goat is a small indie group of friends, if this file was obtained without purchase,
// please support our efforts by purchasing a copy from the Unity Asset Store.  Thanks

Shader "Hidden/EditorPaint/GreyscaleAlpha"
{
	Properties
	{
		_MainTex("Base (RGB)", 2D) = "white" {}
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			sampler2D _Source;
			float4 LayerPositionScale;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;

				o.uv *= LayerPositionScale.zw;
				o.uv += LayerPositionScale.xy;
				return o;
			}
			
			float4 frag (v2f i) : SV_Target
			{
				float4 col = tex2D(_Source, i.uv);

				float greyColor = col.r;
				col = greyColor;
				col.a = 1;
				
				return col;
			}
			ENDCG
		}
	}
}
