extends RigidBody3D

const EXPLOSION = preload("res://Scenes/WeaponScenes/explosion.tscn")
@export var explosion_time : float = 0.5
@export var accent_color : String

var materials = {
	"blue" : preload("res://Materials/blue_laser_mat.tres"), 
	"pink" : preload("res://Materials/pink_laser_mat.tres"),
	"red" : preload("res://Materials/red_laser_mat.tres"),
	}

func _on_area_3d_body_entered(body: Node3D) -> void:
	$ExplosionTimer.start(explosion_time)

func launch(impulse : Vector3):
	apply_impulse(Vector3.ZERO, impulse)
	linear_velocity = impulse

func explode():
#	accent_color = materials.values()[ randi() % materials.size() ]
	var explosion = EXPLOSION.instantiate()
	var mat = materials.get(accent_color, materials["pink"])
	explosion.get_node("MeshInstance3D").material_override = mat
	explosion.global_position = global_position
	get_tree().current_scene.add_child(explosion)
	queue_free()

"""
TODO

Explosion screen shake
Explosion sound effect

"""
	
