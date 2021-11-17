Shader "outlineShader"
{
    Properties
    {
        _Color("Main Color", Color) = (0.5,0.5,0.5,1)
        _MainTex ("Texture", 2D) = "white" {}
        _OutlineColor("Outline color", Color) = (0,0,0,1)
        _OutlineWidth("Outline width", Range(1.0, 5.0)) = 1.01
    }
    
    CGINCLUDE
    #include "UnityCG.cginc"
    
    struct appdata {
        float4 vertex : POSITION; 
        float3 normal : NORMAL; 
    };

    struct vertToFrag { 
        float4 pos : POSITION; 
        float3 normal : NORMAL; 
    };

    float _OutlineWidth;
    float4 _OutlineColor; 

    vertToFrag vert(appdata v) {
        v.vertex.xyz *= _OutlineWidth; 
        vertToFrag output;
        output.pos = UnityObjectToClipPos(v.vertex); 
        return output; 
    }

    ENDCG
    
    SubShader
    {
       Pass //Render the Outline 
       { 
           ZWrite Off 

           CGPROGRAM 
           
           #pragma vertex vert
           #pragma fragment frag 
           
           half4 frag(vertToFrag i) : COLOR 
           {
               return _OutlineColor;
           }
           ENDCG 
       }

       Pass //Normal render  
       { 
           ZWrite On

           Material {
               Diffuse[_Color]
               Ambient[_Color]
           }

           Lighting On

           SetTexture[_MainTex] {
               ConstantColor[_Color]
           }

           SetTexture[_MainTex]
           {
               Combine previous * primary DOUBLE
           }
       }
    }
}
