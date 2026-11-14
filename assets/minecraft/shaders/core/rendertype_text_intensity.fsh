#version 330
#extension GL_ARB_separate_shader_objects : require

#include <minecraft:fog.glsl>
#include <minecraft:dynamictransforms.glsl>
#include <minecraft:oit.glsl>

uniform sampler2D Sampler0;

layout(location = 0) in float sphericalVertexDistance;
layout(location = 1) in float cylindricalVertexDistance;
layout(location = 2) in vec4 vertexColor;
layout(location = 3) in vec2 texCoord0;
layout(location = 4) in float forceFullAlpha;

#ifdef OIT_ALPHA_ONLY
layout(location = 0) out float outAlpha;
#elif defined(OIT_ACCUMULATE)
layout(location = 0) out vec4 outColor;
layout(location = 1) out float outTransmittance;
#elif !defined(OIT_DEPTH_BOUNDS)
layout(location = 0) out vec4 fragColor;
#endif

void main() {
    vec4 color = texture(Sampler0, texCoord0).rrrr * vertexColor * ColorModulator;
    if (color.a < 0.001) {
        discard;
    }
    if (forceFullAlpha > 0.0) {
        color.a = 1.0;
    }
    color = apply_fog(color, sphericalVertexDistance, cylindricalVertexDistance, FogEnvironmentalStart, FogEnvironmentalEnd, FogRenderDistanceStart, FogRenderDistanceEnd, FogColor);

#ifdef OIT_ALPHA_ONLY
    outAlpha = color.a;
#elif defined(OIT_ACCUMULATE)
    oit_accumulate(color, outColor, outTransmittance);
#elif defined(OIT_DEPTH_BOUNDS)
    oit_depth_bounds(color.a);
#else
    fragColor = color;
#endif
}
