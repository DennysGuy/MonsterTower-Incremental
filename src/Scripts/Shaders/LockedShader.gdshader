shader_type canvas_item;

uniform float gray_strength : hint_range(0.0, 1.0) = 1.0;
uniform float darkness : hint_range(0.0, 1.0) = 0.35;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);

	float gray = dot(tex.rgb, vec3(0.299, 0.587, 0.114));
	vec3 gray_color = vec3(gray) * darkness;

	tex.rgb = mix(tex.rgb, gray_color, gray_strength);

	COLOR = tex;
}