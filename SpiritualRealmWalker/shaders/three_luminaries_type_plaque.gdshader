shader_type canvas_item;
render_mode unshaded;

uniform vec2 element_size = vec2(61.0, 37.0);
uniform vec4 ink : source_color = vec4(0.026, 0.083, 0.132, 1.0);
uniform vec4 peacock : source_color = vec4(0.06, 0.24, 0.28, 1.0);
uniform vec4 gold_shadow : source_color = vec4(0.38, 0.26, 0.12, 1.0);
uniform vec4 gold_light : source_color = vec4(0.96, 0.79, 0.43, 1.0);
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
    vec2 p = local_pixel / element_size;
    float value = dot(source.rgb, vec3(0.299, 0.587, 0.114));
    vec3 painted = mix(ink.rgb, peacock.rgb, abs(p.x - 0.5) * 0.70 + p.y * 0.13);
    vec2 q = abs(local_pixel - element_size * 0.5) - element_size * 0.5 + vec2(4.0);
    float contour = length(max(q, vec2(0.0))) + min(max(q.x, q.y), 0.0) - 2.0;
    float line = 1.0 - smoothstep(0.55, 1.3, abs(contour));
    vec3 gilding = mix(gold_shadow.rgb, gold_light.rgb, 0.82 - p.y * 0.28);
    painted = mix(painted, gilding, line * 0.95);
    painted += vec3((value - 0.5) * 0.01);
    // 类型牌与同稀有度插图框配色一致，文字由游戏独立绘制。
    vec3 rarity_face = rarity_color.rgb * (0.88 + 0.12 * clamp(value, 0.0, 1.0));
    vec3 rarity_edge = mix(rarity_color.rgb, vec3(1.0, 0.98, 0.91), 0.14);
    rarity_face = mix(rarity_face, rarity_edge, line * 0.65);
    painted = mix(painted, rarity_face, rarity_strength);
    COLOR = vec4(painted, source.a) * node_color;
}
