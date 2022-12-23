// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Copyright 2018 Prized Goat
// Prized Goat is a small indie group of friends, if this file was obtained without purchase,
// please support our efforts by purchasing a copy from the Unity Asset Store.  Thanks

Shader "Hidden/EditorPaint/CreateProceduralTexShader"
{
	Properties
		{
		}

	SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma target 3.0
			#pragma vertex vert
			#pragma fragment frag

			float hardness;
			float rdx;
			float rdy;

			struct appdata
			{
				float4 vertex : POSITION;
				float4 texcoord : TEXCOORD0;
			};

			struct v2f
			{
				float4 pos : POSITION;
				float2 uv : TEXCOORD0;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos( v.vertex );
				o.uv = (v.texcoord.xy - float2(0.5f, 0.5f)) * 2.1;  //offset center and scale up.  the extra 0.1 (aka -5% size) keeps edge bleeding from happening.
				return o;
			}

			float4 frag(v2f i) : COLOR
			{
									//invert then scale bias so center is 1 and outside of uv edge is 0
				float distance = saturate(length(i.uv));
				hardness = lerp(1.0f, 20, hardness);
				distance = pow(distance, hardness);
				distance = saturate(distance);

				float4 output;
				output.x = distance;
				output.y = distance;
				output.z = distance;
				output.a = 1.0f;

				// Set the outside edge pixels to white so they bleed correctly
				if (i.uv.x <= (-1.0f + rdx) || i.uv.x >= (1.0f - rdx) || i.uv.y <= (-1.0f + rdy) || i.uv.y >= (1.0f - rdy))
				{
					output.rgb = 1.0f;
					output.a = 0.0f;
				}

				return output;
			}
		ENDCG
		}
	}
}
