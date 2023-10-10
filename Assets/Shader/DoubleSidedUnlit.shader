Shader "Custom/DoubleSidedUnlit"
{
    Properties
    {
        _MainTex ("Main Texture (Front)", 2D) = "white" {}
        _BackTex ("Back Texture", 2D) = "white" {}
        _Cutoff ("Cutoff", Range(0, 1)) = 0.5
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            Name "Unlit"
            Cull Off
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float3 viewDir : TEXCOORD1;
                float3 normal : TEXCOORD2;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            sampler2D _BackTex;
            float _Cutoff;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.viewDir = normalize(UnityWorldSpaceViewDir(v.vertex));
                return o;
            }

            half4 frag (v2f i) : SV_Target
            {
                half4 col;
                if (dot(i.normal, i.viewDir) > 0.0)
                {
                    col = tex2D(_MainTex, i.uv);
                }
                else
                {
                    col = tex2D(_BackTex, i.uv);
                }
                clip(col.a - _Cutoff);
                return col;
            }
            ENDCG
        }
    }
}
