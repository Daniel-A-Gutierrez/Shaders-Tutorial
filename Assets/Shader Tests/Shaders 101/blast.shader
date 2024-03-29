﻿Shader "ShaderTutorial/blast"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Noise("Noise" , 2D) = "white" {}
		_spd("Speed", Range(0,.1)) = 0
		_magn("Magnitude" , Range(0,.1)) = 0 
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

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
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTex;
			sampler2D _Noise;
			float _spd;
			float _magn;
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv + _magn*fixed2(tex2D(_Noise,i.uv + fixed2(0, _Time[1] )*_spd   ).x ,0));
				// just invert the colors
			return col;
			}
			ENDCG
		}
	}
}
