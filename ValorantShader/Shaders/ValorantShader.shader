Shader "Custom/ValorantShader"
{
    Properties
    {
        [Header(Textures)]
        [Space(5)]
        _MainTex ("Main Texture", 2D) = "white" {}
        _NormalMap ("Normal Map", 2D) = "bump" {}

        [Space(10)]

        [Header(Surface)]
        [Space(5)]
        _Color ("Color", Color) = (1,1,1,1)
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        [PowerSlider(4)] _Brightness ("Brightness", Range(0, 10)) = 0

        [Space(10)]

        [Header(Fresnel)]
        [Space(5)]
        [HDR] _Emission ("Emission", color) = (0,0,0)
        _FresnelColor ("Fresnel Color", Color) = (1,1,1,1)
        [PowerSlider(4)] _FresnelExponent ("Fresnel Exponent", Range(0, 4)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue"="Geometry" }
        LOD 200

        CGPROGRAM

        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _NormalMap;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_NormalMap;
            float4 screenPos;

            float3 worldNormal;
            float3 viewDir;
            INTERNAL_DATA
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;
        float4 _MainTex_ST;

        half3 _Emission;
        float3 _FresnelColor;
        float _FresnelExponent;

        float _Brightness;

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Calculate screen space texture
            float2 textureCoordinate = IN.screenPos.xy / IN.screenPos.w;
            float aspect = _ScreenParams.x / _ScreenParams.y;
            textureCoordinate.x = textureCoordinate.x * aspect;
            textureCoordinate = TRANSFORM_TEX(textureCoordinate, _MainTex);
            fixed4 color = tex2D(_MainTex, textureCoordinate);

            // Multiply & set rgb
            color *= _Color;
            o.Albedo = color.rgb;
            o.Alpha = color.a;

            // Set surfaces
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;

            // Set normal map 
            half3 tangantNormal = UnpackNormal(tex2D(_NormalMap, IN.uv_NormalMap));
            o.Normal = tangantNormal;

            // Calculate fresnel
            float z = dot(IN.viewDir, float3(0,0,1));
            float fresnel = pow(abs(1 - z), _FresnelExponent * 10);
			float3 fresnelColor = fresnel * _FresnelColor;

            // Set fresnel
			o.Emission = _Emission + fresnelColor + (color * _Brightness);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
