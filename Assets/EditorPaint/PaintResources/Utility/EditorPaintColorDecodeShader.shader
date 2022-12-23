// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Copyright 2018 Prized Goat
// Prized Goat is a small indie group of friends, if this file was obtained without purchase,
// please support our efforts by purchasing a copy from the Unity Asset Store.  Thanks

Shader "Hidden/EditorPaint/ColorDecode"
{
	Properties
	{
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

      // Decodes uint packed color data to output
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

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex );
				o.uv = v.uv;
				return o;
			}

			 float2 PackedTextureSize;
			 Texture2D<uint> PackedTexture;

			 // Unpacks R11G11B10 color from a uint32
			 float3 UnpackTexture( uint packedInput )
			 {
				 float3 unpackedColor = float3(0,0,0);
				 unpackedColor.r = (float)((packedInput) & 0x000007ff) / 2047.0f;
				 unpackedColor.g = (float)((packedInput >> 11) & 0x000007ff) / 2047.0f;
				 unpackedColor.b = (float)((packedInput >> 22) & 0x000003ff) / 1023.0f;

				 return unpackedColor;
			 }

			float4 frag (v2f i) : SV_Target
			{
				float4 output;

				// Unpack and store
				uint packedData = PackedTexture.Load( int3(i.uv.x * PackedTextureSize.x, i.uv.y * PackedTextureSize.y, 0) );
				output.rgb = UnpackTexture( packedData );
				output.a = 1;

				return output;
			}
			ENDCG
		}
	}
}
