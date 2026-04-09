shader_type canvas_item;

const vec3 c1 = vec3(0.95, 0.25, 0.25); // red
const vec3 c2 = vec3(1.0, 0.55, 0.1);   // orange
const vec3 c3 = vec3(1.0, 0.85, 0.25);  // yellow
const vec3 c4 = vec3(0.25, 0.9, 0.4);   // green
const vec3 c5 = vec3(0.65, 0.3, 1.0);   // purple

void fragment() {
	float t = TIME * 0.6;

	// smooth wave
	float v = sin(UV.x * 5.0 + t);
	v = v * 0.5 + 0.5;

	vec3 color;

	// 5-band mapping (clean + readable)
	if (v < 0.2) {
		color = c1;
	} else if (v < 0.4) {
		color = c2;
	} else if (v < 0.6) {
		color = c3;
	} else if (v < 0.8) {
		color = c4;
	} else {
		color = c5;
	}

	COLOR = texture(TEXTURE, UV) * vec4(color, 1.0);
}