shader_type canvas_item;
render_mode unshaded;

uniform vec2 element_size = vec2(327.0, 83.0);
uniform vec4 ink : source_color = vec4(0.025, 0.078, 0.139, 1.0);
uniform vec4 peacock : source_color = vec4(0.069, 0.302, 0.353, 1.0);
uniform vec4 gold_shadow : source_color = vec4(0.39, 0.255, 0.11, 1.0);
uniform vec4 gold_light : source_color = vec4(0.96, 0.80, 0.49, 1.0);
uniform vec4 rarity_color : source_color = vec4(0.40, 0.48, 0.52, 1.0);
uniform float rarity_strength : hint_range(0.0, 1.0) = 0.45;
uniform bool rarity_full_banner = false;
varying vec2 local_pixel;
varying vec4 node_color;

void vertex() {
    local_pixel = VERTEX;
    node_color = COLOR;
}

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

void fragment() {
    vec4 source = texture(TEXTURE, UV);
    vec2 p = local_pixel / element_size;
    float native_value = dot(source.rgb, vec3(0.299, 0.587, 0.114));
    float fold = smoothstep(0.30, 0.46, native_value);
    vec3 painted = mix(ink.rgb, peacock.rgb, clamp(pow(abs(p.x - 0.5) * 2.0, 1.6) * 0.67 + p.y * 0.12, 0.0, 1.0));
    painted *= 0.82 + fold * 0.25;
    painted += vec3((hash(floor(local_pixel * 1.4)) - 0.5) * 0.015);
    vec2 texel = TEXTURE_PIXEL_SIZE * 3.0;
    float nearest_alpha = min(min(texture(TEXTURE, UV + vec2(texel.x, 0.0)).a, texture(TEXTURE, UV - vec2(texel.x, 0.0)).a), min(texture(TEXTURE, UV + vec2(0.0, texel.y)).a, texture(TEXTURE, UV - vec2(0.0, texel.y)).a));
    float edge = smoothstep(0.15, 0.55, source.a - nearest_alpha);
    float fold_line = smoothstep(0.73, 0.87, native_value) * 0.18;
    vec3 gilding = mix(gold_shadow.rgb, gold_light.rgb, clamp(0.76 - p.y * 0.26, 0.0, 1.0));
    painted = mix(painted, gilding, max(edge, fold_line));
    if (rarity_full_banner) {
        // 包括中央标题带与两侧卷尾的完整纹饰，与插图框使用同一稀有度色。
        vec3 rarity_face = rarity_color.rgb * (0.82 + fold * 0.16);
        vec3 rarity_edge = mix(rarity_color.rgb, vec3(1.0, 0.98, 0.91), 0.14);
        rarity_face = mix(rarity_face, rarity_edge, max(edge * 0.85, fold_line * 0.45));
        painted = mix(painted, rarity_face, rarity_strength);
    } else {
        // 普通卡牌保留原来的深色镶金底与窄色带。
        float rarity_band = (1.0 - smoothstep(0.21, 0.32, p.y)) * smoothstep(0.06, 0.18, p.y);
        painted = mix(painted, rarity_color.rgb, rarity_band * rarity_strength);
    }
    COLOR = vec4(painted, source.a) * node_color;
}
