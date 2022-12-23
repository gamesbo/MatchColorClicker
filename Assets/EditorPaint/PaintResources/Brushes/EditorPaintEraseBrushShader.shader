// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Copyright 2018 Prized Goat
// Prized Goat is a small indie group of friends, if this file was obtained without purchase,
// please support our efforts by purchasing a copy from the Unity Asset Store.  Thanks

Shader "Hidden/EditorPaint/Brush/Erase" 
{
	Properties
	{
	}

		SubShader{

		Tags{ "ForceSupported" = "True" "RenderType" = "Overlay" }

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
			
			struct appdata_t
			{
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
				float2 uv2 : TEXCOORD1;
			};

			float4 _Color;
			float4 _LocationScale;
			sampler2D _BrushTex;
			sampler2D _BackgroundTex;
			sampler2D _BackgroundBlendAlphaTex;
			float4x4 _RotationMatrix;
	
			v2f vert(appdata_t v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = v.texcoord.xy;
				o.uv = mul(_RotationMatrix, o.uv.xyxy - float4(0.5, 0.5, 0, 0)).xy + 0.5f;
		
				o.uv2 = v.texcoord.xy - 0.5f;
				o.uv2.x *= _LocationScale.z;
				o.uv2.y *= _LocationScale.w;
				o.uv2.xy += _LocationScale.xy;

				return o;
			}
	
			float4 frag(v2f i) : SV_Target
			{
				float brushTex = tex2D(_BrushTex, i.uv).x;
				float4 backTex = tex2D(_BackgroundTex, i.uv2);
				float backBlendAlpha = tex2D(_BackgroundBlendAlphaTex, i.uv2);
				float4 output;

				output = backTex;
				output /= backBlendAlpha;

				float alpha = backBlendAlpha;
				alpha -= (1.0f - brushTex) * _Color.a;
				alpha = saturate(alpha);

				output *= alpha;
				output.a = 1;

				return output;
			}
			ENDCG
		}

		///====================
		/// Layer Blend Alpha pass
		///====================
		Pass
		{
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
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
				float2 uv2 : TEXCOORD1;
			};

			float4 _Color;
			float4 _LocationScale;
			sampler2D _BrushTex;
			sampler2D _BackgroundTex;
			sampler2D _BackgroundBlendAlphaTex;
			float4x4 _RotationMatrix;

			v2f vert(appdata_t v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = v.texcoord.xy;
				o.uv = mul(_RotationMatrix, o.uv.xyxy - float4(0.5, 0.5, 0, 0)).xy + 0.5f;

				o.uv2 = v.texcoord.xy - 0.5f;
				o.uv2.x *= _LocationScale.z;
				o.uv2.y *= _LocationScale.w;
				o.uv2.xy += _LocationScale.xy;

				return o;
			}

			float4 frag(v2f i) : SV_Target
			{
				float brushTex = tex2D(_BrushTex, i.uv).x;
				float backBlendAlpha = tex2D(_BackgroundBlendAlphaTex, i.uv2);
				float4 output;

				output = backBlendAlpha;
				output -= (((1.0f - brushTex) * _Color.a));
				output = saturate(output);

				output.a = 1;

				return output;
			}
			ENDCG
		}
	}

		Fallback off
}
