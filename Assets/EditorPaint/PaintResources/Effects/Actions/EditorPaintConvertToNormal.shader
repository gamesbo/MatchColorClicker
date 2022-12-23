// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Copyright 2018 Prized Goat
// Prized Goat is a small indie group of friends, if this file was obtained without purchase,
// please support our efforts by purchasing a copy from the Unity Asset Store.  Thanks

Shader "Hidden/EditorPaint/Convert To Normal" 
{
	Properties
	{
		bumpStrength("Bump Strength", Range(0.0, 100.0)) = 10
		resolutionX("Resolution X", Range(0, 8192)) = 2048
		resolutionY("Resolution Y", Range(0, 8192)) = 2048
		// This value is checked by the script to decide if it should apply the shader to both the active and inactive texture
		ApplyToInactiveTexture("ApplyToInactiveTexture", Range(0,1)) = 0
	} 

	SubShader {

		Tags { "ForceSupported" = "True" "RenderType"="Overlay" } 
		
		Lighting Off 
		Blend SrcAlpha OneMinusSrcAlpha 
		Cull Off 
		ZWrite Off 
		ZTest Always 
		
		///====================
		/// Diffuse pass
		///====================
		Pass {	
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0

			struct appdata_t {
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				float2 texcoord : TEXCOORD0;
			};

			sampler2D _MainTex;
			sampler2D _BlendAlphaTex;
			float bumpStrength;
			int resolutionX;
			int resolutionY;
			// This value is checked by the script to decide if it should apply the shader to both the active and inactive texture
			int ApplyToInactiveTexture;
			
			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord = v.texcoord;
				return o;
			}

			float sampleSobel(in float2 uv)
			{
				float weight = 1.0;
				float f = tex2D(_MainTex, uv).x;
				return f * weight - (weight * 0.5);
			}

			float4 frag (v2f i) : SV_Target
			{
				float4 color = tex2D(_MainTex, i.texcoord);
				float alpha = tex2D(_BlendAlphaTex, i.texcoord);
				color /= alpha;
				
				float3 normal = float3(0,0,1);

				float xTexel = 1.0f / resolutionX;
				float yTexel = 1.0f / resolutionY;

				float center = color.x;
				float hor = tex2D(_MainTex, i.texcoord + float2(xTexel, 0)).x - center;
				float ver = tex2D(_MainTex, i.texcoord + float2(0, yTexel)).x - center;

				normal = cross(float3(1, 0, hor * bumpStrength),
								float3(0, 1, ver * bumpStrength));
				
				normal = normalize(normal);
				color.rgb = (normal + 1) * 0.5f;

				color *= alpha;
				color.a = 1;

				return color;
			}
			ENDCG 
		}

		///====================
		/// BlendAlpha pass
		///====================
		Pass{
				CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 3.0

				struct appdata_t {
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f {
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
				float4 color = tex2D(_BlendAlphaTex, i.texcoord);
				color.a = 1;

				return color;
			}
				ENDCG
			}
	} 
	
	Fallback off 
}
