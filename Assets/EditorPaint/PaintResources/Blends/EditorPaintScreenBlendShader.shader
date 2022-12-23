// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Copyright 2018 Prized Goat
// Prized Goat is a small indie group of friends, if this file was obtained without purchase,
// please support our efforts by purchasing a copy from the Unity Asset Store.  Thanks

Shader "Hidden/EditorPaint/Blend/Screen" 
{
   Properties
   {
   }

   SubShader
   {

      Tags{ "ForceSupported" = "True" "RenderType" = "Overlay" }

      Lighting Off
      Blend SrcAlpha OneMinusSrcAlpha
      Cull Off
      ZWrite Off
      ZTest Always

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
         };

         sampler2D _Source1Tex;
         sampler2D _Source2Tex;
		 float _LayerOpacity;
		 float4 LayerPositionScale;

         v2f vert( appdata_t v )
         {
            v2f o;
            o.pos = UnityObjectToClipPos( v.vertex );
            o.uv = v.texcoord.xy;

			o.uv *= LayerPositionScale.zw;
			o.uv += LayerPositionScale.xy;
            return o;
         }

         float4 frag( v2f i ) : SV_Target
         {
            float4 source1 = tex2D( _Source1Tex, i.uv);  //foreground
            float4 source2 = tex2D( _Source2Tex, i.uv); //background

            float4 screenResult = 1.0f - ( 1.0f - source2 ) * ( 1.0f - source1 );
			float4 output = lerp(source1, screenResult, _LayerOpacity);
			// Trim the render space because of layer matrix features
			if (i.uv.x > 1 || i.uv.x < 0 || i.uv.y > 1 || i.uv.y < 0)
			{
				output = source1;
			}
			output.a = 1;

            return output;
         }
         ENDCG
      }
   }

   Fallback off
}