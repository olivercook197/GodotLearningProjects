shader_type canvas_item;

uniform float dissolve : hint_range(0.0, 1.0) = 0.0;
uniform float feather : hint_range(0.0, 0.2) = 0.02;

void fragment()
{
	vec4 tex = texture(TEXTURE, UV);

	float alpha = 1.0 - smoothstep(
		1.0 - dissolve - feather,
		1.0 - dissolve,
		UV.y
	);

	COLOR = vec4(tex.rgb, tex.a * alpha);
}