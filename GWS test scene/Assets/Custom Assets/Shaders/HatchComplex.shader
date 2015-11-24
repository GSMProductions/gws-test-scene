Shader "Custom/Hatching Custom" {
    Properties {
        _Color ("Main Color", Color) = (0.5,0.5,0.5,1)
        _MainTex ("Base (RGB)", 2D) = "white" {}

        _Hatch0 ("Hatch 0", 2D) = "white" {}
        _Hatch1 ("Hatch 1", 2D) = "white" {}        
        _Hatch2 ("Hatch 2", 2D) = "white" {}
        _Hatch3 ("Hatch 3", 2D) = "white" {}        
        _Hatch4 ("Hatch 4", 2D) = "white" {}        
        _Hatch5 ("Hatch 5", 2D) = "white" {}
        lightIntensity("Light Intensity", Range(0,1)) = 0.25                    
    }
    SubShader {
        Tags { "RenderType" = "Opaque" }
        CGPROGRAM
        #pragma target 3.0
        //#pragma surface surf SimpleLambert
        #pragma vertex vert
        #pragma fragment frag

        sampler2D _Hatch0;
        sampler2D _Hatch1;
        sampler2D _Hatch2;
        sampler2D _Hatch3;
        sampler2D _Hatch4;
        sampler2D _Hatch5;

        sampler2D _MainTex;
        float4 _Color;
        half lightIntensity;

        float4 vert(float4 v:POSITION) : SV_POSITION {
            return mul (UNITY_MATRIX_MVP, v);
        }

        fixed4 frag() : SV_Target {
            return fixed4(1.0,0.0,0.0,1.0);
        }

        struct Input 
        {
            float2 uv_MainTex : TEXCOORD0;
            //float2 uv_Detail;
            //float2 uv_BumpMap;
            float3 viewDir;
            float alpha;
            float2 uv_Hatch0;
        };

        ENDCG
    }
    Fallback "Diffuse"
}