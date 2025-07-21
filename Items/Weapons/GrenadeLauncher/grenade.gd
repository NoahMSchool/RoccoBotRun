extends RigidBody3D

const EXPLOSION = preload("res://Items/Weapons/GrenadeLauncher/explosion.tscn")
@export var explosion_time : float = 0.5
@export var accent_color : String
@export var damage : int
@export var target_group = "enemies"
func _on_area_3d_body_entered(body: Node3D) -> void:
	$ExplosionTimer.start(explosion_time)

func launch(impulse : Vector3):
	apply_impulse(Vector3.ZERO, impulse)
	linear_velocity = impulse

func explode():
#	accent_color = materials.values()[ randi() % materials.size() ]
	var explosion = EXPLOSION.instantiate()
	var mat = Globals.glow_materials.get(accent_color, Globals.glow_materials["pink"])
	explosion.get_node("MeshInstance3D").material_override = mat
	explosion.global_position = global_position
	explosion.damage = damage
	get_tree().current_scene.add_child(explosion)
	queue_free()

"""
TODO

Explosion screen shake

Check if there is better way to detect first collision so I can remove the area3d node

"""
	
