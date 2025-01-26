//
//  RippleEffect.metal
//  iEmirati
//
//  Created by TY on 26-01-2025.
//

#include <metal_stdlib>
using namespace metal;

struct VertexOut {
    float4 position [[position]];
    float2 texCoord;
};

vertex VertexOut vertex_main(const device float4* vertexArray [[buffer(0)]],
                             const device float2* texCoordArray [[buffer(1)]],
                             uint vertexID [[vertex_id]]) {
    VertexOut out;
    out.position = vertexArray[vertexID];
    out.texCoord = texCoordArray[vertexID];
    return out;
}

fragment float4 fragment_main_with_bloom(VertexOut in [[stage_in]],
                                         texture2d<float> texture [[texture(0)]],
                                         constant float& time [[buffer(0)]],
                                         constant float2& rippleCenter [[buffer(1)]],
                                         constant float& frequency [[buffer(2)]]) {
    constexpr sampler textureSampler (mag_filter::linear, min_filter::linear);

    // Calculate distance from ripple center
    float2 uv = in.texCoord;
    float distance = length(uv - rippleCenter);

    // Ripple effect with bloom
    float ripple = sin(distance * frequency - time * 5.0) * exp(-distance * 10.0);
    float bloom = exp(-distance * 20.0); // Bloom effect decay

    // Sample the texture and apply bloom
    float4 color = texture.sample(textureSampler, uv);
    color.rgb += ripple * bloom; // Add bloom to the ripple

    return float4(color.rgb, 1.0);
}
