shader_type canvas_item;
render_mode unshaded;

uniform vec2 element_size = vec2(275.0, 210.0);
uniform vec4 ink : source_color = vec4(0.021, 0.070, 0.107, 1.0);
uniform vec4 gold_shadow : source_color = vec4(0.32, 0.21, 0.09, 1.0);
uniform vec4 gold_light : source_color = vec4(0.96, 0.78, 0.43, 1.0);
uniform vec4 rarity_color : source_color = vec4(0.306, 0.718, 0.776, 1.0);
uniform float rarity_strength : hint_range(0.0, 1.0) = 0.0;
varying vec2 local_pixel;
varying vec4 node_color;

void vertex() {
    local_pixel = VERTEX;
    node_color = COLOR;
}

void fragment() {
    vec4 source = texture(TEXTURE, UV);
    // Sample only the original alpha contour, so all attack/skill/power silhouettes survive.
    vec2 texel = TEXTURE_PIXEL_SIZE * 2.2;
    float neighbour = min(min(texture(TEXTURE, UV + vec2(texel.x, 0.0)).a, texture(TEXTURE, UV - vec2(texel.x, 0.0)).a), min(texture(TEXTURE, UV + vec2(0.0, texel.y)).a, texture(TEXTURE, UV - vec2(0.0, texel.y)).a));
    float outer_edge = smoothstep(0.12, 0.58, source.a - neighbour);
    // Native beveled highlight provides a slender secondary inside line.
    float value = dot(source.rgb, vec3(0.299, 0.587, 0.114));
    float highlight_edge = smoothstep(0.66, 0.82, value) * 0.48;
    float gleam = clamp(0.5 + (1.0 - local_pixel.y / element_size.y) * 0.38, 0.0, 1.0);
    vec3 gilding = mix(gold_shadow.rgb, gold_light.rgb, gleam);
    vec3 painted = ink.rgb + vec3(0.016, 0.025, 0.031) * value;
    painted = mix(painted, gilding, max(outer_edge * 0.90, highlight_edge));
    // 罕见与稀有给整圈实体框着色，透明插图窗口保持不变。
    vec3 rarity_face = rarity_color.rgb * (0.84 + 0.16 * clamp(value * 1.3, 0.0, 1.0));
    vec3 rarity_edge = mix(rarity_color.rgb, vec3(1.0, 0.98, 0.91), 0.14);
    rarity_face = mix(rarity_face, rarity_edge, max(outer_edge * 0.85, highlight_edge * 0.45));
    painted = mix(painted, rarity_face, rarity_strength);
    COLOR = vec4(painted, source.a) * node_color;
}
