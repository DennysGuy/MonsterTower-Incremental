shader_type canvas_item;

uniform vec4 color1 : source_color;
uniform vec4 color2 : source_color;

uniform float threshold = 0.1;
uniform float intensity = 1.0;
uniform float opacity = 0.5;

uniform vec4 glow_color : source_color;

void fragment() {
	vec4 pixel_color = texture(TEXTURE, UV);

	float distance_first = length(pixel_color.rgb - color1.rgb);
	float distance_second = length(pixel_color.rgb - color2.rgb);

	vec4 modified_glow_color = glow_color;
	modified_glow_color.a = opacity;

	if (distance_first < threshold || distance_second < threshold) {
		COLOR = mix(
			pixel_color,
			modified_glow_color * intensity,
			modified_glow_color.a
		);
	} else {
		COLOR = pixel_color;
	}
}