shader_type canvas_item;
render_mode blend_add;

uniform vec4 beam_color : source_color = vec4(0.91, 1.0, 1.0, 1.0);
uniform vec4 outline_color : source_color = vec4(0.5, 1.0, 0.96, 1.0);

uniform float speed = 2.0;
uniform float frequency = 25.0;
uniform float amplitude = 0.08;

uniform float beam_thickness : hint_range(0.0, 1.0) = 0.15;
uniform float outline_thickness : hint_range(0.0, 1.0) = 0.35;

uniform float glow = 1.0;
uniform float outline_glow = 0.5;

uniform float progress : hint_range(0.0, 1.0) = 1.0;

float random(vec2 uv) {
	return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453123);
}

float noise(vec2 uv) {
	vec2 i = floor(uv);
	vec2 f = fract(uv);

	float a = random(i);
	float b = random(i + vec2(1.0, 0.0));
	float c = random(i + vec2(0.0, 1.0));
	float d = random(i + vec2(1.0, 1.0));

	vec2 u = smoothstep(0.0, 1.0, f);

	return mix(a, b, u.x)
		+ (c - a) * u.y * (1.0 - u.x)
		+ (d - b) * u.x * u.y;
}

void fragment() {

	// Line2D UV:
	// UV.x = along line
	// UV.y = across line width

	float t = TIME * speed;

	// Generate animated distortion
	float n = noise(vec2(UV.x * frequency, t));

	// Offset beam center
	float center = 0.5 + ((n - 0.5) * amplitude);

	// Distance from center of beam
	float dist = abs(UV.y - center);

	// Main beam
	float beam = smoothstep(
		beam_thickness,
		beam_thickness - 0.02,
		dist
	);

	// Outline
	float outline = smoothstep(
		outline_thickness,
		outline_thickness - 0.05,
		dist
	);

	outline -= beam;
	outline = clamp(outline, 0.0, 1.0);

	// Fade with progress
	beam *= progress;
	outline *= progress;

	vec4 final_color = vec4(0.0);

	final_color += beam * (
		beam_color + vec4(glow, glow, glow, 0.0)
	);

	final_color += outline * (
		outline_color + vec4(outline_glow, outline_glow, outline_glow, 0.0)
	);

	COLOR = final_color;
}