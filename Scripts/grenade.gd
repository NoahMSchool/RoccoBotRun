extends RigidBody3D

const EXPLOSION = preload("res://Scenes/WeaponScenes/explosion.tscn")
@export var explosion_time : float = 0.5

func _on_area_3d_body_entered(body: Node3D) -> void:
	$ExplosionTimer.start(explosion_time)

func launch(impulse : Vector3):
	apply_impulse(Vector3.ZERO, impulse)
	linear_velocity = impulse

func explode():
	var explosion = EXPLOSION.instantiate()
	explosion.global_position = global_position
	get_tree().current_scene.add_child(explosion)
	queue_free()

"""
TODO

Explosion screen shake
Explosion sound effect

"""
	
