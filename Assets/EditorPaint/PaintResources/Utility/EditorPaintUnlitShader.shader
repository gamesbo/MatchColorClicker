// Copyright 2018 Prized Goat
// Prized Goat is a small indie group of friends, if this file was obtained without purchase,
// please support our efforts by purchasing a copy from the Unity Asset Store.  Thanks

Shader "Hidden/EditorPaint/Unlit"
{
	Properties
	{
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Gamma ("Gamma", Float) = 1.0
	}

	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100
	
		Pass
		{  
			CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#pragma target 2.0
				#pragma multi_compile_fog
			
				#include "UnityCG.cginc"

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

				sampler2D _MainTex;
				float4 _MainTex_ST;
				float _Gamma;
			
				v2f vert (appdata_t v)
				{
					v2f o;
					o.vertex = UnityObjectToClipPos(v.vertex);
					o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
					return o;
				}
			
				float4 frag (v2f i) : SV_Target
				{
					float4 col = tex2D(_MainTex, i.texcoord);
					col.rgb = pow(col.rgb, _Gamma);
					UNITY_OPAQUE_ALPHA(col.a);
					return col;
				}
			ENDCG
		}
	}
}
