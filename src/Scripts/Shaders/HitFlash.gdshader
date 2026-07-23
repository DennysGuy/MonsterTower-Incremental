shader_type canvas_item;

uniform bool active = false;
uniform float flash_strength : hint_range(0.0, 1.0) = 0.8;

void fragment() {
	vec4 previous_color = texture(TEXTURE, UV);

	vec3 flash_color = mix(
		previous_color.rgb,
		vec3(1.0),
		flash_strength
	);

	vec3 final_color = previous_color.rgb;

	if (active) {
		final_color = flash_color;
	}

	COLOR = vec4(final_color, previous_color.a);
}