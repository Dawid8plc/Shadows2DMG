#if OPENGL
    #define SV_POSITION POSITION
    #define VS_SHADERMODEL vs_3_0
    #define PS_SHADERMODEL ps_3_0
#else
    #define VS_SHADERMODEL vs_4_0_level_9_3
    #define PS_SHADERMODEL ps_4_0_level_9_3
#endif

texture SourceTexture; 
          
sampler inputSampler = sampler_state      
{
            Texture   = <SourceTexture>;
            
            MipFilter = Point;
            MinFilter = Point;
            MagFilter = Point;
            
            AddressU  = Clamp;
            AddressV  = Clamp;
};
   
float2 TextureDimensions;

void VS(in float3 InPos : POSITION, in float2 InTex : TEXCOORD0, out float4 Position : POSITION, out float2 TexCoord : TEXCOORD0)
{
    // transform the position to the screen
    Position = float4(InPos,1) + float4(TextureDimensions.x, -TextureDimensions.y, 0, 0);
    TexCoord = InTex;
}


float4 HorizontalReductionPS(in float4 Position : POSITION, in float2 TexCoord : TEXCOORD0) : COLOR0
{
	  float2 color = tex2D(inputSampler, TexCoord);
	  float2 colorR = tex2D(inputSampler, TexCoord + float2(TextureDimensions.x,0));
	  float2 result = min(color,colorR);
      return float4(result,0,1);
}

float4 CopyPS(in float4 Position : POSITION, in float2 TexCoord : TEXCOORD0) : COLOR0
{
	return tex2D(inputSampler, TexCoord);
}


technique HorizontalReduction
{
    pass P0
    {          
        VertexShader = compile VS_SHADERMODEL VS();
        PixelShader = compile PS_SHADERMODEL HorizontalReductionPS();
    }
}

technique Copy
{
    pass P0
    {          
        VertexShader = compile VS_SHADERMODEL VS();
        PixelShader = compile PS_SHADERMODEL CopyPS();
    }
}