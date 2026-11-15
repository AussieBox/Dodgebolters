#version 330
#extension GL_ARB_separate_shader_objects : require

#if !defined(IS_GUI) && !defined(IS_SEE_THROUGH)
#if !defined(IS_GUI) && !defined(IS_SEE_THROUGH)
#include <minecraft:fog.glsl>
#include <minecraft:sample_lightmap.glsl>
#endif

#include <minecraft:sample_lightmap.glsl>
#endif

#include <minecraft:dynamictransforms.glsl>
#include <minecraft:projection.glsl>

layout(location = 0) in vec3 Position;
layout(location = 1) in vec4 Color;
layout(location = 2) in vec2 UV0;
#if !defined(IS_GUI) && !defined(IS_SEE_THROUGH)
#if !defined(IS_GUI) && !defined(IS_SEE_THROUGH)
layout(location = 3) in ivec2 UV2;
#endif
#endif

#if !defined(IS_GUI) && !defined(IS_SEE_THROUGH)
#if !defined(IS_GUI) && !defined(IS_SEE_THROUGH)
uniform sampler2D Sampler2;
layout(location = 0) out float sphericalVertexDistance;
layout(location = 1) out float cylindricalVertexDistance;
#endif

#endif

layout(location = 2) out vec4 vertexColor;
layout(location = 3) out vec2 texCoord0;
layout(location = 4) out float forceFullAlpha;

void main() {
    vec3 modRollerTitleColor = vec3(0.71372549, 0.356862745, 1.0);
    bool isModRollerTitle = (distance(Color.rgb, modRollerTitleColor) < 0.005);
    bool isModRollerTitleShadow = (distance(Color.rgb, modRollerTitleColor * 0.25) < 0.005);
    
    forceFullAlpha = 0.0;
    if (isModRollerTitle || isModRollerTitleShadow) {
        forceFullAlpha = 1.0;
    }

    vec3 modRollerColor = vec3(0.866666667, 0.509803922, 1.0);
    bool isModRoller = (distance(Color.rgb, modRollerColor) < 0.005);
    bool isModRollerShadow = (distance(Color.rgb, modRollerColor * 0.25) < 0.005);

#if !defined(IS_GUI) && !defined(IS_SEE_THROUGH)
    vertexColor = Color * sample_lightmap(Sampler2, UV2);
#else
    vertexColor = Color;
#endif

    vec3 animationPos = Position;
    if (isModRoller || isModRollerShadow) {
        float alpha = 1.0 - Color.a;
        float curve = 1.0 - pow(1.0 - alpha, 3.0);
        float smoothAlpha = mix(alpha, curve, 0.9); 
        animationPos.x = mix(Position.x+5000, Position.x, smoothAlpha);
        vertexColor.a = 1.0;
    }

    gl_Position = ProjMat * ModelViewMat * vec4(animationPos, 1.0);

#if !defined(IS_GUI) && !defined(IS_SEE_THROUGH)
    sphericalVertexDistance = fog_spherical_distance(animationPos);
    cylindricalVertexDistance = fog_cylindrical_distance(animationPos);
#endif
    texCoord0 = UV0;
}
