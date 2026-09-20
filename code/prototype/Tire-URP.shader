Shader "Custom/URP/Tire"
{
    // URP-compatible replacement for RVP's Assets/Shaders/Tires.shader.
    //
    // The original is a legacy Surface Shader ("#pragma surface surf
    // Lambert vertex:vert addshadow"). URP's built-in-to-URP material
    // converter cannot touch Surface Shaders at all -- they are simply
    // unsupported, which is the whole reason this file exists.
    //
    // What actually needed porting was small: everything in the original
    // surf() function is boilerplate (sample a texture, tint it, feed it
    // to Lambert lighting) that URP/Lit already does. The ONLY genuinely
    // custom logic is the vert() function -- a vertex deformation driven
    // by a "deform map" texture and a world-space "deform normal" vector,
    // which squashes the tyre mesh under load. That function is ported
    // below with its exact original math, inside URP's vertex stage.
    //
    // STATUS: written and reasoned through against URP ShaderLab/HLSL
    // conventions, not compiled -- there is no Unity/URP package
    // available in the environment this was written in. Treat as a
    // strong first draft: paste it in, let the Shader Graph/URP compiler
    // find anything this got wrong, and iterate. The deformation math in
    // the vert() function is transcribed directly from the original
    // source, not reinvented, so that part should need the least fixing.
    //
    // See racinggameideas/code/prototype/RVP-TRIAGE.md for the full
    // triage this shader was produced from.

    Properties
    {
        _BaseColor ("Base Color", Color) = (1,1,1,1)
        _BaseMap ("Base Map", 2D) = "white" {}
        _DeformMap ("Deform Map", 2D) = "white" {}
        _DeformNormal ("Deform Normal (world space)", Vector) = (0,0,0,0)
        _Smoothness ("Smoothness", Range(0.0, 1.0)) = 0.0
    }

    SubShader
    {
        Tags
        {
            "RenderType" = "Opaque"
            "RenderPipeline" = "UniversalPipeline"
            "Queue" = "Geometry"
        }
        LOD 200

        Pass
        {
            Name "ForwardLit"
            Tags { "LightMode" = "UniversalForward" }

            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            // Keep this in step with whatever your project's URP asset
            // actually enables -- these are the common ones, trim or
            // extend to match.
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
            #pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
            #pragma multi_compile_fog

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

            TEXTURE2D(_BaseMap);       SAMPLER(sampler_BaseMap);
            TEXTURE2D(_DeformMap);     SAMPLER(sampler_DeformMap);

            CBUFFER_START(UnityPerMaterial)
                float4 _BaseColor;
                float4 _DeformMap_ST;
                float4 _DeformNormal;   // world-space vector, as in the original
                float _Smoothness;
            CBUFFER_END

            struct Attributes
            {
                float4 positionOS : POSITION;
                float3 normalOS   : NORMAL;
                float2 uv         : TEXCOORD0;
            };

            struct Varyings
            {
                float4 positionHCS : SV_POSITION;
                float2 uv          : TEXCOORD0;
                float3 normalWS    : TEXCOORD1;
                float3 positionWS  : TEXCOORD2;
            };

            Varyings vert(Attributes IN)
            {
                Varyings OUT;

                // --- The ported deformation, transcribed from the
                // original CGPROGRAM vert() function. Original used
                // tex2Dlod against object-space _DeformNormal transformed
                // by unity_WorldToObject; here we work directly in world
                // space since URP's TransformObjectToWorldNormal already
                // gives us a world-space normal, which is a cleaner
                // equivalent -- verify this produces the same visual
                // result as the original once you can compare them
                // side by side, since this is the one place the port
                // deviates from a literal line-by-line translation.

                float3 normalWS = TransformObjectToWorldNormal(IN.normalOS);

                // tex2Dlod -> SAMPLE_TEXTURE2D_LOD in URP/SRP Core.
                float4 deformSample = SAMPLE_TEXTURE2D_LOD(
                    _DeformMap, sampler_DeformMap,
                    TRANSFORM_TEX(IN.uv, _DeformMap), 0);

                float3 deformDirWS = normalize(_DeformNormal.xyz);
                float squishDot = saturate(dot(-normalWS, deformDirWS));

                float3 offsetWS =
                    (deformDirWS * squishDot * 1.1
                     + normalWS * pow(squishDot, 1.5)
                       * length(_DeformNormal.xyz)
                       * (1 - saturate(dot(normalWS, deformDirWS))))
                    * deformSample.rgb;

                float3 positionWS = TransformObjectToWorld(IN.positionOS.xyz);
                positionWS += offsetWS;

                // --- End of ported deformation ---

                OUT.positionWS = positionWS;
                OUT.positionHCS = TransformWorldToHClip(positionWS);
                OUT.normalWS = normalWS;
                OUT.uv = IN.uv;
                return OUT;
            }

            half4 frag(Varyings IN) : SV_Target
            {
                half4 baseTex = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, IN.uv);
                half3 albedo = baseTex.rgb * _BaseColor.rgb;

                InputData lightingInput = (InputData)0;
                lightingInput.positionWS = IN.positionWS;
                lightingInput.normalWS = normalize(IN.normalWS);
                lightingInput.viewDirectionWS = GetWorldSpaceNormalizeViewDir(IN.positionWS);
                lightingInput.shadowCoord = TransformWorldToShadowCoord(IN.positionWS);

                SurfaceData surfaceInput = (SurfaceData)0;
                surfaceInput.albedo = albedo;
                surfaceInput.alpha = 1.0;
                surfaceInput.smoothness = _Smoothness;
                surfaceInput.occlusion = 1.0;

                return UniversalFragmentPBR(lightingInput, surfaceInput);
            }
            ENDHLSL
        }

        // Needed for the tyre to cast shadows correctly -- the original
        // shader used "addshadow" on the surface pragma to get this for
        // free. URP needs an explicit ShadowCaster pass. This one also
        // applies the same vertex deformation so the shadow matches the
        // deformed silhouette, not the undeformed mesh.
        Pass
        {
            Name "ShadowCaster"
            Tags { "LightMode" = "ShadowCaster" }

            HLSLPROGRAM
            #pragma vertex ShadowVert
            #pragma fragment ShadowFrag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            TEXTURE2D(_DeformMap); SAMPLER(sampler_DeformMap);
            CBUFFER_START(UnityPerMaterial)
                float4 _DeformMap_ST;
                float4 _DeformNormal;
            CBUFFER_END

            struct Attributes
            {
                float4 positionOS : POSITION;
                float3 normalOS   : NORMAL;
                float2 uv         : TEXCOORD0;
            };
            struct Varyings { float4 positionHCS : SV_POSITION; };

            Varyings ShadowVert(Attributes IN)
            {
                Varyings OUT;
                float3 normalWS = TransformObjectToWorldNormal(IN.normalOS);
                float4 deformSample = SAMPLE_TEXTURE2D_LOD(
                    _DeformMap, sampler_DeformMap,
                    TRANSFORM_TEX(IN.uv, _DeformMap), 0);
                float3 deformDirWS = normalize(_DeformNormal.xyz);
                float squishDot = saturate(dot(-normalWS, deformDirWS));
                float3 offsetWS =
                    (deformDirWS * squishDot * 1.1
                     + normalWS * pow(squishDot, 1.5)
                       * length(_DeformNormal.xyz)
                       * (1 - saturate(dot(normalWS, deformDirWS))))
                    * deformSample.rgb;
                float3 positionWS = TransformObjectToWorld(IN.positionOS.xyz) + offsetWS;
                OUT.positionHCS = TransformWorldToHClip(positionWS);
                return OUT;
            }
            half4 ShadowFrag(Varyings IN) : SV_Target { return 0; }
            ENDHLSL
        }
    }

    FallBack "Universal Render Pipeline/Lit"
}

// -----------------------------------------------------------------------
// Tires-Bump.shader porting note:
//
// The original Tires-Bump.shader adds three things over the base Tires
// shader: an occlusion map, a normal map, and Standard (PBR) lighting
// instead of Lambert. The vert() deformation function is byte-for-byte
// identical between the two originals -- confirmed by direct comparison
// of both source files during the triage this shader was produced from.
//
// To extend the shader above into the Bump variant: add _OcclusionMap and
// _NormalMap textures to Properties and the CBUFFER, sample them in
// frag(), feed the normal map through TransformTangentToWorld() (which
// needs a tangent-space basis -- add TANGENT to Attributes and pass a
// tangentWS/bitangentWS pair through Varyings), and set
// surfaceInput.occlusion from the occlusion sample instead of the
// hardcoded 1.0 above. The vert() function itself needs no changes.
// -----------------------------------------------------------------------
