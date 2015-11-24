Shader "Custom/Hatching" {
    Properties {
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _RampTex ("Ramp", 2D) = "white" {}
        _Hatch0 ("Hatch 0", 2D) = "white" {}
        _Hatch1 ("Hatch 1", 2D) = "white" {}        
        _Hatch2 ("Hatch 2", 2D) = "white" {}
        _Hatch3 ("Hatch 3", 2D) = "white" {}        
        _Hatch4 ("Hatch 4", 2D) = "white" {}        
        _Hatch5 ("Hatch 5", 2D) = "white" {}
        lightIntensity("Opacity", Range(0,1)) = 0.25                    
    }
    SubShader {
        Tags { "RenderType" = "Opaque" }
        CGPROGRAM
        #pragma target 3.0
        //#pragma surface surf SimpleLambert
        //#pragma surface surf Lambert finalcolor:FinalColor noforwardadd
        #pragma surface surf Lambert finalcolor:FinalColor
        sampler2D _MainTex;
        sampler2D _RampTex;

        sampler2D _Hatch0;
        sampler2D _Hatch1;
        sampler2D _Hatch2;
        sampler2D _Hatch3;
        sampler2D _Hatch4;
        sampler2D _Hatch5;

        half lightIntensity;

        half3 Hatching(float2 _uv, half _intensity)
        {
            half3 hatch0 = (half3)tex2D(_Hatch0, _uv).rgb;
            half3 hatch1 = (half3)tex2D(_Hatch1, _uv).rgb;
            half3 hatch2 = (half3)tex2D(_Hatch2, _uv).rgb;
            half3 hatch3 = (half3)tex2D(_Hatch3, _uv).rgb;
            half3 hatch4 = (half3)tex2D(_Hatch4, _uv).rgb;
            half3 hatch5 = (half3)tex2D(_Hatch5, _uv).rgb;
           
            const half hatchingScale = 6.0 / 7.0;
            half hatchedIntensity = min(_intensity, hatchingScale);
            half remainingIntensity = _intensity - hatchedIntensity;
            half unitHatchedIntensity = hatchedIntensity / hatchingScale;
           
            half3 weightsA = saturate((unitHatchedIntensity * 6.0) + half3(-5.0, -4.0, -3.0));
            half3 weightsB = saturate((unitHatchedIntensity * 6.0) + half3(-2.0, -1.0, 0.0));
           
            weightsB.yz = saturate(weightsB.yz - weightsB.xy);
            weightsB.x = saturate(weightsB.x - weightsA.z);
            weightsA.yz = saturate(weightsA.yz - weightsA.xy);
           
            half3 hatching = remainingIntensity;
            hatching += hatch0 * weightsA.x;
            hatching += hatch1 * weightsA.y;
            hatching += hatch2 * weightsA.z;
            hatching += hatch3 * weightsB.x;
            hatching += hatch4 * weightsB.y;
            hatching += hatch5 * weightsB.z;
            return hatching;
        }

        struct Input 
        {
            float2 uv_MainTex : TEXCOORD0;
            float2 uv_Hatch0;

        };

        void FinalColor(Input IN, SurfaceOutput o, inout half4 color)
        {
            // Calculate pixel intensity and tint
            //half intensity = dot(color.rgb, half3(0.3, 0.59, 0.11));
            half intensity = dot(color.rgb, half3(0.299, 0.587, 0.114));
            //sqrt( 0.299*R^2 + 0.587*G^2 + 0.114*B^2 )

            half3 tint = color.rgb / max(intensity, 1.0);
            float3 ramp = tex2D(_RampTex, float2(intensity, 1.0)).rgb;
            // Apply hatching
            half3 shading =  Hatching(IN.uv_Hatch0, intensity);
            if (intensity < 0.5) {
                color.r = 2 * tint.r * shading.r;
            } else {
                color.r = 1 - 2 * (1 - tint.r) * (1 - shading.r);
            }
            if (intensity < 0.5) {
                color.g = 2 * tint.g * shading.g;
            } else {
                color.g = 1 - 2 * (1 - tint.g) * (1 - shading.g);
            }            
            if (intensity < 0.5) {
                color.b = 2 * tint.b * shading.b;
            } else {
                color.b = 1 - 2 * (1 - tint.b) * (1 - shading.b);
            }

            //color.rgb = tint * Hatching(IN.uv_Hatch0, intensity * (ramp+0.5));
            //color.rgb = half3(color.r, 0, 0);
        }

        void surf(Input IN, inout SurfaceOutput o)
        {
            o.Albedo = (half3)tex2D(_MainTex, IN.uv_MainTex).rgb;
        }
        ENDCG
    }
    Fallback "Diffuse"
}