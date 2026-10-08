shader_type canvas_item;
render_mode unshaded;

// One original 4K texture: no duplicated outlines or moving overlay copies.
// Coordinates refer to the illustration UV, so letterboxing remains unchanged.
uniform float animation_time = 0.0;
// Production uses the render clock, independent of a parent disabling processing.
// Deterministic frame export is the only caller that enables preview_clock.
uniform bool preview_clock = false;
uniform float motion_strength : hint_range(0.0, 1.0) = 1.0;
varying vec4 vertex_tint;

void vertex() {
	vertex_tint = COLOR;
}

float oval(vec2 uv, vec2 center, vec2 radius) {
	return 1.0 - smoothstep(0.45, 1.0, length((uv - center) / radius));
}

float wave(float phase, float offset) {
	return 0.5 * (sin(phase + offset) - sin(offset));
}

float protect(vec2 uv, vec2 center, vec2 radius) {
	return 1.0 - smoothstep(1.0, 1.12, length((uv - center) / radius));
}

void fragment() {
	vec2 uv = UV;
	float clock_seconds = preview_clock ? animation_time : TIME;
	float phase = clock_seconds * 6.28318530718 / 12.0;
	// Sleeves are anchored near the upper arms; free ends receive most motion.
	float left_hem = oval(uv, vec2(0.585, 0.590), vec2(0.105, 0.120));
	float left_sleeve = oval(uv, vec2(0.604, 0.416), vec2(0.080, 0.066));
	float right_hem = oval(uv, vec2(0.900, 0.657), vec2(0.098, 0.148));
	float right_sleeve = oval(uv, vec2(0.878, 0.443), vec2(0.080, 0.083));
	float lower_robe = oval(uv, vec2(0.811, 0.746), vec2(0.073, 0.089));
	float left_hair = oval(uv, vec2(0.675, 0.328), vec2(0.046, 0.056));
	float right_hair = oval(uv, vec2(0.824, 0.336), vec2(0.045, 0.058));
	// Preserve anatomy, central garment structure and the sacred black moon.
	float fixed = max(protect(uv, vec2(0.747, 0.204), vec2(0.085, 0.125)),
		protect(uv, vec2(0.748, 0.258), vec2(0.033, 0.049)));
	fixed = max(fixed, protect(uv, vec2(0.643, 0.480), vec2(0.027, 0.029)));
	fixed = max(fixed, protect(uv, vec2(0.851, 0.487), vec2(0.030, 0.032)));
	fixed = max(fixed, protect(uv, vec2(0.747, 0.550), vec2(0.050, 0.310)));
	float free_weight = 1.0 - fixed;
	vec2 drift = vec2(0.0);
	drift.x = left_hem * wave(phase, 0.0) + right_hem * wave(phase, 1.4)
		+ left_sleeve * wave(phase, 0.5) + right_sleeve * wave(phase, 2.1)
		+ lower_robe * wave(phase, 0.8);
	drift.y = left_hem * wave(phase, 1.2) + right_hem * wave(phase, 2.0)
		+ left_sleeve * wave(phase, 0.9) + right_sleeve * wave(phase, 1.1)
		+ lower_robe * wave(phase, 1.7);
	drift += vec2(left_hair * wave(phase * 2.0, 0.4)
		+ right_hair * wave(phase * 2.0, 1.2),
		0.3 * (left_hair + right_hair) * wave(phase * 2.0, 0.0));
	drift = clamp(drift, vec2(-1.0), vec2(1.0));
	vec2 sample_uv = uv + drift * vec2(12.0 / 3840.0, 8.0 / 2400.0)
		* free_weight * motion_strength;
	vec4 painted = texture(TEXTURE, sample_uv);
	float luma = dot(painted.rgb, vec3(0.2126, 0.7152, 0.0722));
	float robe_light = clamp(left_hem + right_hem + left_sleeve + right_sleeve
		+ lower_robe, 0.0, 1.0) * free_weight;
	// Modulate existing bright paint only; no extra particles over the text area.
	float shimmer = 0.12 * sin(phase * 2.0) * robe_light
		* smoothstep(0.52, 0.88, luma) * motion_strength;
	COLOR = vec4(painted.rgb * (1.0 + shimmer), painted.a) * vertex_tint;
}
