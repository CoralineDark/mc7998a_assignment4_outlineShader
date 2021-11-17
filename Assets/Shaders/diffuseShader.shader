Shader "diffuse lighting and rainbow"
{
    Properties {
        _Color ("Diffuse Material Color", Color) = (1,1,1,1)
    }
    SubShader {
        Pass {
            Tags {"LightMode" = "ForwardBase"} 
            Blend SrcAlpha OneMinusSrcAlpha
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            uniform float4 _LightColor0; 
            uniform float4 _Color; 
            struct vertexInput {
                float4 vertex : POSITION;
                float4 normal : NORMAL; 
            };
            struct vertexOutput {
                float4 pos : SV_POSITION;
                float4 col : COLOR;
            };
            vertexOutput vert(vertexInput input)
            {
                vertexOutput output; 
                float4x4 modelMatrix = unity_ObjectToWorld; 
                float4x4 modelMatrixInverse = unity_WorldToObject;
                float3 normalDirection = UnityObjectToWorldNormal(input.normal);
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz); 
                float3 diffuseReflection = _LightColor0.rgb * _Color.rgb * max(0.0, dot(normalDirection, lightDirection));
                output.col = float4(diffuseReflection, 1.0); 
                output.pos = UnityObjectToClipPos(input.vertex); 
                return output;
            }
            float4 frag(vertexOutput input) : COLOR 
            {
                return input.col;
            }
            ENDCG
        }
    }
}