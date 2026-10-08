shader_type canvas_item;
render_mode unshaded;

uniform sampler2D cloud_fill : source_color, filter_linear, repeat_disable;
uniform sampler2D original_art : source_color, filter_linear, repeat_disable;
// R: original subject coverage. G: clean-plate replacement with motion margin.
uniform sampler2D subject_mask : filter_linear, repeat_disable;
uniform float animation_time = 0.0;
uniform bool preview_clock = false;
uniform float motion_strength : hint_range(0.0, 1.0) = 1.0;
varying vec4 vertex_tint;

void vertex() { vertex_tint = COLOR; }

float oval(vec2 uv, vec2 center, vec2 radius) {
	return 1.0 - smoothstep(0.2, 1.0, length((uv - center) / radius));
}

float protect(vec2 uv, vec2 center, vec2 radius) {
	return 1.0 - smoothstep(1.0, 1.15, length((uv - center) / radius));
}

float wave(float phase, float offset) {
	return 0.5 * (sin(phase + offset) - sin(offset));
}

vec3 clean_background(vec2 uv) {
	vec2 safe = clamp(uv, vec2(0.001), vec2(0.999));
	float coverage = texture(subject_mask, safe).g;
	return mix(texture(original_art, safe).rgb, texture(cloud_fill, safe).rgb, coverage);
}

void fragment() {
	vec2 uv = UV;
	float clock_seconds = preview_clock ? animation_time : TIME;
	float phase = clock_seconds * 6.28318530718 / 12.0;
	// Two cross-faded advected cloud planes maintain continuous inward motion.
	// Sampling farther from the chest over time moves visible paint toward it.
	vec2 target = vec2(0.746, 0.443);
	float radial_distance = length((uv - target) * vec2(1.6, 1.0));
	float flow_region = smoothstep(0.48, 0.58, uv.x)
		* (1.0 - smoothstep(0.965, 1.0, uv.x))
		* smoothstep(0.07, 0.18, uv.y)
		* (1.0 - smoothstep(0.88, 0.99, uv.y))
		* (1.0 - smoothstep(0.44, 0.63, radial_distance));
	flow_region *= 1.0 - protect(uv, vec2(0.950, 0.173), vec2(0.037, 0.144));
	float travel_a = fract(clock_seconds / 12.0);
	float travel_b = fract(travel_a + 0.5);
	float blend = pow(sin(travel_a * 3.14159265359), 2.0);
	vec2 advection = (uv - target) * 0.085;
	advection += vec2(-advection.y / 1.6, advection.x * 1.6) * 0.08;
	vec3 cloud_a = clean_background(uv + advection * travel_a);
	vec3 cloud_b = clean_background(uv + advection * travel_b);
	vec3 background = mix(clean_background(uv), mix(cloud_b, cloud_a, blend), flow_region);

	// The complete person and moon translate together, preserving all anatomy.
	vec2 person_uv = uv - vec2(0.0, 6.0 / 2400.0 * sin(phase));
	float left_sleeve = oval(person_uv, vec2(0.600, 0.414), vec2(0.089, 0.066));
	float right_sleeve = oval(person_uv, vec2(0.881, 0.448), vec2(0.085, 0.084));
	float left_hem = oval(person_uv, vec2(0.584, 0.590), vec2(0.105, 0.123));
	float right_hem = oval(person_uv, vec2(0.910, 0.672), vec2(0.097, 0.135));
	float lower_hem = oval(person_uv, vec2(0.809, 0.751), vec2(0.070, 0.094));
	float left_hair = oval(person_uv, vec2(0.674, 0.326), vec2(0.048, 0.054));
	float right_hair = oval(person_uv, vec2(0.830, 0.344), vec2(0.049, 0.056));
	float fixed = protect(person_uv, vec2(0.7465, 0.2294), vec2(0.0810, 0.1295));
	fixed = max(fixed, protect(person_uv, vec2(0.643, 0.480), vec2(0.027, 0.029)));
	fixed = max(fixed, protect(person_uv, vec2(0.851, 0.487), vec2(0.030, 0.032)));
	fixed = max(fixed, protect(person_uv, vec2(0.747, 0.550), vec2(0.049, 0.310)));
	float free = 1.0 - fixed;
	vec2 cloth = vec2(
		left_hem * wave(phase, 0.0) + right_hem * wave(phase, 1.5)
		+ left_sleeve * wave(phase, 0.5) + right_sleeve * wave(phase, 2.2)
		+ lower_hem * wave(phase, 0.8),
		left_hem * wave(phase, 1.1) + right_hem * wave(phase, 2.1)
		+ left_sleeve * wave(phase, 0.9) + right_sleeve * wave(phase, 1.3)
		+ lower_hem * wave(phase, 1.7));
	vec2 hair = vec2(left_hair * wave(phase * 2.0, 0.4)
		+ right_hair * wave(phase * 2.0, 1.2),
		0.35 * (left_hair + right_hair) * wave(phase * 2.0, 0.0));
	vec2 deform = clamp(cloth, vec2(-1.0), vec2(1.0)) * vec2(28.0 / 3840.0, 18.0 / 2400.0)
		+ hair * vec2(13.0 / 3840.0, 8.0 / 2400.0);
	vec2 subject_uv = person_uv + deform * free;
	vec4 subject = texture(TEXTURE, subject_uv);
	float alpha = texture(subject_mask, subject_uv).r;
	float robe_region = clamp(left_sleeve + right_sleeve + left_hem + right_hem + lower_hem, 0.0, 1.0) * free;
	float luma = dot(subject.rgb, vec3(0.2126, 0.7152, 0.0722));
	// A moving illumination wave follows existing embroidery, without particles.
	float light_wave = 0.15 * sin(phase * 2.0 - subject_uv.y * 18.0 + subject_uv.x * 9.0);
	float star_light = light_wave * smoothstep(0.48, 0.87, luma) * robe_region;
	float sun = oval(subject_uv, vec2(0.7465, 0.212), vec2(0.003, 0.004));
	subject.rgb *= 1.0 + star_light + sun * 0.025 * sin(phase);
	vec3 animated = mix(background, subject.rgb, alpha);
	// A zero-strength debug view must exactly reproduce the original painting.
	COLOR = vec4(mix(texture(TEXTURE, uv).rgb, animated, motion_strength), 1.0) * vertex_tint;
}
