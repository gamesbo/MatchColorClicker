// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Copyright 2018 Prized Goat
// Prized Goat is a small indie group of friends, if this file was obtained without purchase,
// please support our efforts by purchasing a copy from the Unity Asset Store.  Thanks

Shader "Hidden/EditorPaint/BufferGamma"
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

            #define GAMMA 2.2f
            #define INVERSE_GAMMA 1.0f / GAMMA
			
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

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTex;

			float4 frag (v2f i) : SV_Target
			{
				float4 col = tex2D(_MainTex, i.uv);
				
				// Correct for gamma issues that show up when a project is set to Linear
				col = pow(col, GAMMA);  // Single gamma value
				col.a = 1;

				return col;
			}
			ENDCG
		}
	}
}
