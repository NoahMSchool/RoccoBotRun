shader_type spatial;


void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec3 base = vec3(0.2, 0.6, 1.0);
    ALBEDO = base;
    EMISSION = base * (0.5 + 0.5 * sin(TIME * 8.0 + UV.y * PI*2.50));
    ALPHA = 0.5;
    ROUGHNESS = 0.1;
    METALLIC  = 0.0;

}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
