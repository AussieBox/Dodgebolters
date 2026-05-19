#version 330

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:dynamictransforms.glsl>
#moj_import <minecraft:projection.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;

uniform sampler2D Sampler2;

out float sphericalVertexDistance;
out float cylindricalVertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;

void main() {
    vec3 modRollerColor = vec3(0.866666667, 0.509803922, 1.0);

    bool isModRoller = (distance(Color.rgb, modRollerColor) < 0.005);
    bool isModRollerShadow = (distance(Color.rgb, modRollerColor * 0.25) < 0.005);
    
    vertexColor = Color * texelFetch(Sampler2, UV2 / 16, 0);

    vec3 animationPos = Position;
    if (isModRoller || isModRollerShadow) {
        float alpha = 1.0 - Color.a;
        float curve = 1.0 - pow(1.0 - alpha, 3.0);
        float smoothAlpha = mix(alpha, curve, 0.9); 
        animationPos.x = mix(Position.x+5000, Position.x, smoothAlpha);
        vertexColor.a = 1.0;
    }

    gl_Position = ProjMat * ModelViewMat * vec4(animationPos, 1.0);

    sphericalVertexDistance = fog_spherical_distance(Position);
    cylindricalVertexDistance = fog_cylindrical_distance(Position);
    texCoord0 = UV0;
}