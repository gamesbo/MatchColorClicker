// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Copyright 2018 Prized Goat
// Prized Goat is a small indie group of friends, if this file was obtained without purchase,
// please support our efforts by purchasing a copy from the Unity Asset Store.  Thanks

Shader "Hidden/EditorPaint/BrushProjector"
{
	Properties
	{
		_ShadowTex ("Cookie", 2D) = "gray" {}
		_FalloffTex ("FallOff", 2D) = "white" {}
	}
	Subshader
	{
		Tags {"Queue"="Overlay"}
		Pass
		{
			ZWrite Off
			ColorMask RGB
			Blend DstColor Zero
			Offset -1, -1

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog
			#include "UnityCG.cginc"
			
			struct v2f
			{
				float4 uvShadow : TEXCOORD0;
				float4 uvFalloff : TEXCOORD1;
				float4 pos : SV_POSITION;
			};
			
			float4x4 unity_Projector;
			float4x4 unity_ProjectorClip;
			
			v2f vert (float4 vertex : POSITION)
			{
				v2f o;
				o.pos = UnityObjectToClipPos (vertex);
				o.uvShadow = mul (unity_Projector, vertex);
				o.uvFalloff = mul (unity_ProjectorClip, vertex);
				return o;
			}
			
			sampler2D _ShadowTex;
			sampler2D _FalloffTex;
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 texS = tex2Dproj (_ShadowTex, UNITY_PROJ_COORD(i.uvShadow));
				texS.a = 1.0-texS.a;
				texS.rgb = lerp(texS.rgb, 1, texS.a);

				fixed4 texF = tex2Dproj (_FalloffTex, UNITY_PROJ_COORD(i.uvFalloff));
				fixed4 res = lerp(fixed4(1,1,1,0), texS, texF.a);
				return res;
			}
			ENDCG
		}
	}
}
