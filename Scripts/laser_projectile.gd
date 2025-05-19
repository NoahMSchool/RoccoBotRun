extends RayCast3D

@export var speed := 50.0
@onready var age = 0
@export var max_age = 100
@export var target_group : String
@export var accent_color : String

var materials = {
	"blue" : preload("res://Materials/blue_laser_mat.tres"), 
	"pink" : preload("res://Materials/pink_laser_mat.tres"),
	"red" : preload("res://Materials/red_laser_mat.tres"),

}
func _ready() -> void:
	var mat = materials.get(accent_color, materials["pink"])
	$MeshInstance3D.material_override = mat
	
func _physics_process(delta: float) -> void:
	age += 1
	position += global_basis * Vector3.FORWARD * speed * delta
	target_position = Vector3.FORWARD * speed * delta
	force_raycast_update()
	var collider = get_collider()
	if is_colliding():
		#print("laser collision", collider)
		if collider.is_in_group(target_group):
			collider.queue_free()
		queue_free() 
	if age > max_age:
		#print("projectile out of range")                
		queue_free()
