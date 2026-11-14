#version 330
#extension GL_ARB_separate_shader_objects : require

// Can't #include in things used during startup, when resource packs don't exist.
// This is a copy of dynamictransforms.glsl and projection.glsl
layout(std140) uniform DynamicTransforms {
    mat4 ModelViewMat;
    mat4 TextureMat;
    vec4 ColorModulator;
    vec3 ModelOffset;
};
layout(std140) uniform Projection {
    mat4 ProjMat;
};

layout(location = 0) in vec3 Position;
layout(location = 1) in vec4 Color;

layout(location = 0) out vec4 vertexColor;

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);
    vertexColor = Color;
    if (Color.a > 0.5019 && Color.a < 0.502) {
        vertexColor.a = 0.0;
    }
}
