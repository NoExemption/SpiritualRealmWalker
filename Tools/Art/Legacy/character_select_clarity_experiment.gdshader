shader_type canvas_item;
render_mode unshaded;

uniform float clarity_strength : hint_range(0.0, 1.5) = 1.0;
uniform float sample_radius : hint_range(1.0, 4.0) = 2.5;
varying vec4 inherited_tint;

void vertex() {
	inherited_tint = COLOR;
}

void fragment() {
	vec2 step_uv = TEXTURE_PIXEL_SIZE * sample_radius;
	vec2 edge = TEXTURE_PIXEL_SIZE * 0.5;
	vec4 source = texture(TEXTURE, UV);
	vec3 nearby = (
		texture(TEXTURE, clamp(UV + vec2(step_uv.x, 0.0), edge, vec2(1.0) - edge)).rgb +
		texture(TEXTURE, clamp(UV - vec2(step_uv.x, 0.0), edge, vec2(1.0) - edge)).rgb +
		texture(TEXTURE, clamp(UV + vec2(0.0, step_uv.y), edge, vec2(1.0) - edge)).rgb +
		texture(TEXTURE, clamp(UV - vec2(0.0, step_uv.y), edge, vec2(1.0) - edge)).rgb
	) * 0.25;
	vec3 luma_weights = vec3(0.2126, 0.7152, 0.0722);
	float detail = dot(source.rgb - nearby, luma_weights);
	// Bound the brightness change to avoid halos around hair, gold edges and stars.
	float adjustment = clamp(detail * clarity_strength, -0.025, 0.025);
	vec3 result = clamp(source.rgb + vec3(adjustment), vec3(0.0), vec3(1.0));
	COLOR = vec4(result, source.a) * inherited_tint;
}
