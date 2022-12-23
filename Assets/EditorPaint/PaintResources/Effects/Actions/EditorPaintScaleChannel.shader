// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Copyright 2018 Prized Goat
// Prized Goat is a small indie group of friends, if this file was obtained without purchase,
// please support our efforts by purchasing a copy from the Unity Asset Store.  Thanks

Shader "Hidden/EditorPaint/Scale Channel"
{
	Properties
	{
		xChannel("Red", Range(0.0, 2.0)) = 1
		yChannel("Green", Range(0.0, 2.0)) = 1
		zChannel("Blue", Range(0.0, 2.0)) = 1
		// This value is checked by the script to decide if it should apply the shader to both the active and inactive texture
		ApplyToInactiveTexture("ApplyToInactiveTexture", Range(0,1)) = 0
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
			float4 vertex : SV_POSITION;
			float2 texcoord : TEXCOORD0;
		};

		sampler2D _MainTex;
		sampler2D _BlendAlphaTex;
		float xChannel;
		float yChannel;
		float zChannel;
		// This value is checked by the script to decide if it should apply the shader to both the active and inactive texture
		int ApplyToInactiveTexture;

		v2f vert(appdata_t v)
		{
			v2f o;
			o.vertex = UnityObjectToClipPos(v.vertex);
			o.texcoord = v.texcoord;
			return o;
		}

		float4 frag(v2f i) : SV_Target
		{
			float4 origColor = tex2D(_MainTex, i.texcoord);
			float alpha = tex2D(_BlendAlphaTex, i.texcoord);
			origColor /= alpha;

			origColor.rgb *= float3(xChannel, yChannel, zChannel);
			
			origColor *= alpha;
			origColor.a = 1;

			return origColor;
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
		sampler2D _BlendAlphaTex;

		v2f vert(appdata_t v)
		{
			v2f o;
			o.vertex = UnityObjectToClipPos(v.vertex);
			o.texcoord = v.texcoord;
			return o;
		}

		float4 frag(v2f i) : SV_Target
		{
			float4 output = tex2D(_BlendAlphaTex, i.texcoord);
			output.a = 1;

			return output;
		}
		ENDCG
	}

	}

		Fallback off
}