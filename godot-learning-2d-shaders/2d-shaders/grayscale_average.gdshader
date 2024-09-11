shader_type canvas_item;

uniform bool enableSteps;
uniform int steps;

void fragment() {
	float value = (COLOR.r + COLOR.g + COLOR.b) / 3.0;

	if(enableSteps) {
		float stepSize = 1.0 / float(steps);
		float fittingStep = round(value / stepSize);
		value = fittingStep * stepSize;
	}

	COLOR.rgb = vec3(value);
}
