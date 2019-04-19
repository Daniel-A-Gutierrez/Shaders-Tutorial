Shader "ShaderTutorial/boxsampler"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags {"Queue" = "Transparent" "RenderType"="Transparent" }
		LOD 100
		ZWrite off

		Pass
		{
			Blend SrcAlpha OneMinusSrcAlpha // blend mode, makes it use alpha

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 box(sampler2D t, float2 uv, float4 s)
			{
				fixed4 c = tex2D(t, uv + float2(-s.x, s.y)) + tex2D(t, uv + float2(0, s.y)) + tex2D(t, uv + float2(s.x, s.y)) +
					tex2D(t, uv + float2(-s.x, 0)) + tex2D(t, uv + float2(0, 0)) + tex2D(t, uv + float2(s.x, 0)) +
					tex2D(t, uv + float2(-s.x, -s.y)) + tex2D(t, uv + float2(0, -s.y)) + tex2D(t, uv + float2(s.x, -s.y));
				return c / 9;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = box(_MainTex,i.uv,_MainTex_TexelSize);
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}
}
