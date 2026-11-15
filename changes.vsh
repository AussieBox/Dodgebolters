> gui

if (Color.a > 0.5019 && Color.a < 0.502){
    vertexColor.a = 0.0;
}

> rendertype_item_entity_translucent_cull

out vec4 tintColor;

tintColor = Color;

> rendertype_text_intensity

out float forceFullAlpha;

replace gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);
with:

vec3 modRollerTitleColor = vec3(0.71372549, 0.356862745, 1.0);

    bool isModRollerTitle = (distance(Color.rgb, modRollerTitleColor) < 0.005);
    bool isModRollerTitleShadow = (distance(Color.rgb, modRollerTitleColor * 0.25) < 0.005);
    
    forceFullAlpha = 0.0;

    vec3 animationPos = Position;
    if (isModRollerTitle || isModRollerTitleShadow) {
        forceFullAlpha = 1.0;
    }

> rendertype_text

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

remove vertexColor = Color * texelFetch(Sampler2, UV2 / 16, 0);
