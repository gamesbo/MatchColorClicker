// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Copyright 2018 Prized Goat
// Prized Goat is a small indie group of friends, if this file was obtained without purchase,
// please support our efforts by purchasing a copy from the Unity Asset Store.  Thanks

Shader "Hidden/EditorPaint/Hue"
{
	Properties
	{
		hue("Hue", Range(0.0, 1.0)) = 0
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
		float hue;
		// This value is checked by the script to decide if it should apply the shader to both the active and inactive texture
		int ApplyToInactiveTexture;

		v2f vert(appdata_t v)
		{
			v2f o;
			o.vertex = UnityObjectToClipPos(v.vertex);
			o.texcoord = v.texcoord;
			return o;
		}

		float3 RGBToHSL(float3 color)
		{
			float3 hsl;
			float minValue = min(min(color.r, color.g), color.b);    //Min. value of RGB
			float maxValue = max(max(color.r, color.g), color.b);    //Max. value of RGB
			float delta = maxValue - minValue;             //Delta RGB value

			hsl.z = (maxValue + minValue) / 2.0; // Luminance

			if (delta == 0.0)		//This is a gray, no chroma...
			{
				hsl.x = 0.0;	// Hue
				hsl.y = 0.0;	// Saturation
			}
			else                    //Chromatic data...
			{
				if (hsl.z < 0.5)
				{
					hsl.y = delta / (maxValue + minValue); // Saturation
				}
				else
				{
					hsl.y = delta / (2.0 - maxValue - minValue); // Saturation
				}

				float deltaR = (((maxValue - color.r) / 6.0) + (delta / 2.0)) / delta;
				float deltaG = (((maxValue - color.g) / 6.0) + (delta / 2.0)) / delta;
				float deltaB = (((maxValue - color.b) / 6.0) + (delta / 2.0)) / delta;

				if (color.r == maxValue)
				{
					hsl.x = deltaB - deltaG; // Hue
				}
				else if (color.g == maxValue)
				{
					hsl.x = (1.0 / 3.0) + deltaR - deltaB; // Hue
				}
				else if (color.b == maxValue)
				{
					hsl.x = (2.0 / 3.0) + deltaG - deltaR; // Hue
				}

				if (hsl.x < 0.0)
				{
					hsl.x += 1.0; // Hue
				}
				else if (hsl.x > 1.0)
				{
					hsl.x -= 1.0; // Hue
				}
			}

			return hsl;
		}

		float HueToRGB(float f1, float f2, float hue)
		{
			if (hue < 0.0)
			{
				hue += 1.0;
			}
			else if (hue > 1.0)
			{
				hue -= 1.0;
			}

			float res;

			if ((6.0 * hue) < 1.0)
			{
				res = f1 + (f2 - f1) * 6.0 * hue;
			}
			else if ((2.0 * hue) < 1.0)
			{
				res = f2;
			}
			else if ((3.0 * hue) < 2.0)
			{
				res = f1 + (f2 - f1) * ((2.0 / 3.0) - hue) * 6.0;
			}
			else
			{
				res = f1;
			}

			return res;
		}

		float3 HSLToRGB(float3 hsl)
		{
			float3 rgb;

			if (hsl.y == 0.0)
			{
				rgb = float3(hsl.z, hsl.z, hsl.z); // Luminance
			}
			else
			{
				float f2;

				if (hsl.z < 0.5)
				{
					f2 = hsl.z * (1.0 + hsl.y);
				}
				else
				{
					f2 = (hsl.z + hsl.y) - (hsl.y * hsl.z);
				}

				float f1 = 2.0 * hsl.z - f2;

				rgb.r = HueToRGB(f1, f2, hsl.x + (1.0 / 3.0));
				rgb.g = HueToRGB(f1, f2, hsl.x);
				rgb.b = HueToRGB(f1, f2, hsl.x - (1.0 / 3.0));
			}

			return rgb;
		}

		float4 frag(v2f i) : SV_Target
		{
			float4 origColor = tex2D(_MainTex, i.texcoord);
			float alpha = tex2D(_BlendAlphaTex, i.texcoord);
			origColor /= alpha;

			float3 hsl = RGBToHSL(origColor.rgb);
			hsl.x += hue - 1;

			float4 finalColor;
			finalColor.rgb = HSLToRGB(hsl);
			
			finalColor *= alpha;
			finalColor.a = 1;

			return finalColor;
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