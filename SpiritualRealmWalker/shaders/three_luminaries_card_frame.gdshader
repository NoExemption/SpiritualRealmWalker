shader_type canvas_item;
render_mode unshaded;

// Node-local coordinates keep the ornament in place when native textures use an atlas.
uniform vec2 frame_size = vec2(300.0, 422.0);
uniform vec4 ink : source_color = vec4(0.027, 0.075, 0.133, 1.0);
uniform vec4 peacock : source_color = vec4(0.055, 0.310, 0.365, 1.0);
uniform vec4 gold_shadow : source_color = vec4(0.39, 0.255, 0.105, 1.0);
uniform vec4 gold : source_color = vec4(0.83, 0.635, 0.32, 1.0);
uniform vec4 gold_light : source_color = vec4(0.98, 0.845, 0.55, 1.0);
uniform float emblem_strength : hint_range(0.0, 1.0) = 0.17;
varying vec2 local_pixel;
varying vec4 node_color;

void vertex() {
    local_pixel = VERTEX;
    node_color = COLOR;
}

float stroke(float distance_value, float thickness) {
    return 1.0 - smoothstep(thickness, thickness + 0.6, abs(distance_value));
}

float round_box(vec2 p, vec2 half_size, float radius) {
    vec2 q = abs(p) - half_size + vec2(radius);
    return length(max(q, vec2(0.0))) + min(max(q.x, q.y), 0.0) - radius;
}

float line_segment(vec2 p, vec2 a, vec2 b) {
    vec2 d = b - a;
    return length(p - a - d * clamp(dot(p - a, d) / dot(d, d), 0.0, 1.0));
}

float star(vec2 p, vec2 position, vec2 scale) {
    vec2 q = abs((p - position) / scale);
    return 1.0 - smoothstep(0.88, 1.05, q.x + q.y + 0.64 * sqrt(q.x * q.y));
}

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

void fragment() {
    vec4 source = texture(TEXTURE, UV);
    vec2 p = local_pixel * vec2(300.0, 422.0) / frame_size;
    vec2 uv = p / vec2(300.0, 422.0);
    float side = pow(abs(uv.x - 0.5) * 2.0, 2.1);
    float bottom = smoothstep(0.88, 1.0, uv.y);
    float parchment_grain = (hash(floor(p * 1.7)) - 0.5) * 0.016;
    float brush = sin(p.x * 0.13 + p.y * 0.20 + sin(p.y * 0.037) * 3.0) * 0.009;
    // A continuous, flat ink field replaces the native embossed description panel.
    vec3 painted = mix(ink.rgb, peacock.rgb, clamp(side * 0.75 + bottom * 0.20, 0.0, 0.88));
    painted += vec3(parchment_grain + brush);
    float source_value = dot(source.rgb, vec3(0.299, 0.587, 0.114));
    painted += (source_value - 0.25) * 0.016;

    vec2 centered = p - vec2(150.0, 211.0);
    float outer = round_box(centered, vec2(146.0, 207.0), 23.0);
    float inner = round_box(centered, vec2(132.5, 193.5), 17.0);
    float dark_keyline = stroke(outer - 1.8, 1.0);
    painted = mix(painted, vec3(0.018, 0.032, 0.040), dark_keyline * 0.85);
    float gold_lines = max(stroke(outer, 0.62), stroke(inner, 0.38) * 0.80);
    float gold_highlight = clamp(0.35 + (1.0 - uv.y) * 0.38 + sin(p.y * 0.087) * 0.15, 0.0, 1.0);
    vec3 gold_ink = mix(gold_shadow.rgb, gold_light.rgb, gold_highlight);
    painted = mix(painted, gold_ink, gold_lines);
    float outer_wash = stroke(outer + 1.2, 1.8) * 0.20;
    painted = mix(painted, gold.rgb, outer_wash);

    // Sparse corner stars and side studs echo the shared sun/moon/star cost seal.
    float ornaments = 0.0;
    ornaments = max(ornaments, star(p, vec2(27.0, 391.0), vec2(5.7, 9.0)));
    ornaments = max(ornaments, star(p, vec2(273.0, 391.0), vec2(5.7, 9.0)));
    ornaments = max(ornaments, star(p, vec2(150.0, 401.5), vec2(4.4, 8.0)));
    ornaments = max(ornaments, star(p, vec2(150.0, 14.0), vec2(4.0, 6.5)));
    ornaments = max(ornaments, star(p, vec2(17.5, 172.0), vec2(2.2, 5.0)));
    ornaments = max(ornaments, star(p, vec2(282.5, 172.0), vec2(2.2, 5.0)));
    ornaments = max(ornaments, stroke(length(p - vec2(17.5, 194.0)), 0.85));
    ornaments = max(ornaments, stroke(length(p - vec2(282.5, 194.0)), 0.85));
    painted = mix(painted, gold_light.rgb, ornaments * 0.90);

    // One subdued three-luminary star instrument shared by all professions.
    vec2 e = p - vec2(150.0, 322.0);
    float radius = length(e);
    float emblem = max(stroke(radius - 73.0, 0.25), stroke(radius - 62.0, 0.20));
    emblem = max(emblem, stroke(radius - 46.0, 0.20) * 0.55);
    float angle = atan(e.y, e.x);
    float dial_dots = step(0.90, cos(angle * 24.0)) * stroke(radius - 68.0, 0.28);
    emblem = max(emblem, dial_dots);
    emblem = max(emblem, stroke(line_segment(e, vec2(0.0, -68.0), vec2(0.0, 68.0)), 0.13) * 0.45);
    // Dark moon with a warm illuminated crescent, displaced from the central text.
    vec2 moon_p = e - vec2(-27.0, -34.0);
    float moon_disk = 1.0 - smoothstep(12.5, 13.3, length(moon_p));
    float moon_shadow = 1.0 - smoothstep(11.5, 12.3, length(moon_p - vec2(-4.0, -1.0)));
    float crescent = moon_disk * (1.0 - moon_shadow);
    painted = mix(painted, vec3(0.018, 0.038, 0.060), moon_disk * emblem_strength * 0.6);
    emblem = max(emblem, crescent * 0.56);
    emblem = max(emblem, stroke(length(moon_p) - 13.0, 0.18) * 0.65);
    emblem = max(emblem, star(e, vec2(29.0, -33.0), vec2(3.7, 7.4)));
    emblem = max(emblem, star(e, vec2(40.0, -18.0), vec2(2.5, 4.5)));
    emblem = max(emblem, star(e, vec2(0.0, -50.0), vec2(2.5, 5.5)));
    emblem = max(emblem, stroke(line_segment(e, vec2(0.0, -50.0), vec2(29.0, -33.0)), 0.13) * 0.65);
    emblem = max(emblem, stroke(line_segment(e, vec2(29.0, -33.0), vec2(40.0, -18.0)), 0.13) * 0.65);
    vec2 sun_p = e - vec2(0.0, 45.0);
    float sun_radius = length(sun_p);
    float sun_angle = atan(sun_p.y, sun_p.x);
    float rays = abs(cos(sun_angle * 8.0));
    emblem = max(emblem, stroke(sun_radius - 8.5, 0.45));
    emblem = max(emblem, stroke(sun_radius - 6.3, 0.15));
    emblem = max(emblem, (1.0 - smoothstep(8.5 + rays * 10.0, 9.2 + rays * 10.0, sun_radius)) * smoothstep(8.0, 9.0, sun_radius) * 0.60);
    emblem = max(emblem, star(e, vec2(-40.0, 43.0), vec2(2.3, 4.0)) * 0.7);
    emblem = max(emblem, star(e, vec2(42.0, 44.0), vec2(2.3, 4.0)) * 0.7);
    float lower_only = smoothstep(241.0, 257.0, p.y) * (1.0 - smoothstep(395.0, 409.0, p.y));
    painted = mix(painted, gold.rgb, emblem * emblem_strength * lower_only);
    COLOR = vec4(painted, source.a) * node_color;
}
