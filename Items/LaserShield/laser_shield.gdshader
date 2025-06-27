shader_type spatial;


void vertex() {
	// Called for every vertex the material is visible on.
}

uniform sampler2D sheild_alpha_tex : source_color;
uniform sampler2D sheild_emmision_tex : source_color;

uniform float emmission_strength = 1.0;
uniform float alpha_strength = 1.0;


void fragment() {
	// Called for every pixel the material is visible on.
	vec3 base_color = vec3(0,0.6,0.8);
	ALBEDO = base_color;


	vec3 emmision_tex = texture(sheild_emmision_tex, UV).rgb;
	EMISSION = emmision_tex*emmission_strength;

	//vec3 alpha_tex = texture(sheild_alpha_tex, UV).rgb;
	//float a = texture(alpha_tex, UV).r;
	//ALPHA = a*alpha_strength;
	ALPHA = 0.6;
	vec2 uv_scrolled = UV;


	vec3 base = vec3(0.2, 0.6, 1.0);
    //ALBEDO = base;
    EMISSION = base * (0.5 + 0.5 * sin(TIME * 5.0 + UV.y * PI*2.50));
    ALPHA = 0.5;
    //ROUGHNESS = 0.1;
    //METALLIC  = 0.0;


}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
