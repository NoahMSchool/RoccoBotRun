extends Resource

class_name CrateType

#use for special animation
enum OPENMODE {
	lid_rotate,
	lid_pop,
	hide
}

@export var place_infront_distance = 0.0
var open_mode : OPENMODE

@export var open_sound : AudioStream

@export var cap_mesh : Mesh
@export var box_mesh : Mesh
@export var cap_mat : Material
@export var box_mat : Material

@export var flip_mesh := true
@export var mesh_scale_overide : float = 1.0
@export var box_offset : Vector3 = Vector3(0,0.4,0)
@export var lid_offset : Vector3 = Vector3(0,0.8,0.4)
