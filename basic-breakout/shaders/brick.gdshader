shader_type canvas_item;

uniform float heat : hint_range(0.0, 1.0) = 0.0;

vec3 get_heat_color(vec3 base_color, float h)
{
	vec3 red    = vec3(1.2, 0.05, 0.0);
	vec3 orange = vec3(1.5, 0.5, 0.0);
	vec3 yellow = vec3(2.0, 1.5, 0.2);
	vec3 white  = vec3(6.0, 5.5, 5.0);

	vec3 color = base_color;

	color = mix(
		color,
		red,
		smoothstep(0.00, 0.25, h)
	);

	color = mix(
		color,
		orange,
		smoothstep(0.25, 0.50, h)
	);

	color = mix(
		color,
		yellow,
		smoothstep(0.50, 0.75, h)
	);

	color = mix(
		color,
		white,
		smoothstep(0.75, 1.00, h)
	);

	return color;
}

void fragment()
{
	vec4 tex = texture(TEXTURE, UV);

	// Distance from center
	vec2 centered_uv = UV - vec2(0.5);
	float dist = length(centered_uv);

	// 0 = center, 1 = edge
	float edge_factor = smoothstep(
		0.1,
		0.7,
		dist * 2.0
	);

	// Center lags behind edges
	float previous_heat = max(0.0, heat - 0.15);

	vec3 center_color = get_heat_color(
		tex.rgb,
		previous_heat
	);

	vec3 edge_color = get_heat_color(
		tex.rgb,
		heat
	);

	vec3 final_color = mix(
		center_color,
		edge_color,
		edge_factor
	);

	COLOR = vec4(final_color, tex.a);
}