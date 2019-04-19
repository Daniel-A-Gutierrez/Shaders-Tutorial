Shader "ShaderTutorial/Shaders101"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_SecondaryTex("Texture",2D) = "white" {}
		_Interpolation("Interpolation", Float) = 0
		_AM("Alpha Multiplier" , Float) = 1
	}
		SubShader
		{
		Tags { "Queue" = "Transparent"  "RenderType" = "Transparent" } //get culling glitches unless you also set queue
		LOD 100
		ZWrite off//also important for transparent shaders

		Pass
		{
			Blend SrcAlpha OneMinusSrcAlpha // blend mode, makes it use alpha
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

			sampler2D _MainTex;
			sampler2D _SecondaryTex;
			float4 _MainTex_ST;
			float _Interpolation;
			float _AM;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
		
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				//fixed4 gradient = fixed4(i.uv.x / 2 + i.uv.y / 4, i.uv.y * 3 / 4,1 - i.uv.x / 4 , 1);
				//fixed4 texcol = tex2D(_MainTex, i.uv); //sample the texture at these UVs
				//fixed4 tex2col = tex2D(_SecondaryTex, i.uv);
				//texcol.a *= _Interpolation;
				//tex2col.a *= (1 - _Interpolation);
				//return _Interpolation*texcol + (1-_Interpolation) * tex2col ;

				fixed4 texcol = tex2D(_MainTex,i.uv);
				fixed lum = texcol.r*.3 + texcol.g * .59 + texcol.b * .011;//equation for luminance
				fixed4 lum4 =  fixed4(lum, lum, lum, texcol.a* _AM);
				lum4 *= fixed4(i.uv.x / 2 + i.uv.y / 4, i.uv.y * 3 / 4, 1 - i.uv.x / 4, 1);//gradient
				return lum4;
			}
			ENDCG
		}
	}
}
