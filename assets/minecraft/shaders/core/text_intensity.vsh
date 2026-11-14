#version 330
#extension GL_ARB_separate_shader_objects : require

#include <minecraft:fog.glsl>
#include <minecraft:dynamictransforms.glsl>
#include <minecraft:projection.glsl>

layout(location = 0) in vec3 Position;
layout(location = 1) in vec4 Color;
layout(location = 2) in vec2 UV0;
layout(location = 3) in ivec2 UV2;

uniform sampler2D Sampler2;

layout(location = 0) out float sphericalVertexDistance;
layout(location = 1) out float cylindricalVertexDistance;
layout(location = 2) out vec4 vertexColor;
layout(location = 3) out vec2 texCoord0;
layout(location = 4) out float forceFullAlpha;

void main() {
    vec3 modRollerTitleColor = vec3(0.71372549, 0.356862745, 1.0);

    bool isModRollerTitle = (distance(Color.rgb, modRollerTitleColor) < 0.005);
    bool isModRollerTitleShadow = (distance(Color.rgb, modRollerTitleColor * 0.25) < 0.005);
    
    forceFullAlpha = 0.0;

    vec3 animationPos = Position;
    if (isModRollerTitle || isModRollerTitleShadow) {
        forceFullAlpha = 1.0;
    }

    gl_Position = ProjMat * ModelViewMat * vec4(animationPos, 1.0);

    sphericalVertexDistance = fog_spherical_distance(Position);
    cylindricalVertexDistance = fog_cylindrical_distance(Position);
    vertexColor = Color * texelFetch(Sampler2, UV2 / 16, 0);
    texCoord0 = UV0;
}
