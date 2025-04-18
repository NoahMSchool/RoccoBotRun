extends Node3D

const LASER_PROJECTILE = preload("res://WeaponScenes/laser_projectile.tscn")
const BLOOM = PI/72
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if $Timer.is_stopped():
		if Input.is_action_pressed("right_action"):
			$Timer.start(0.2)
			$AudioStreamPlayer3D.play()
			
			#Adding projectile
			var projectile = LASER_PROJECTILE.instantiate()
			add_child(projectile)
			projectile.global_transform = global_transform

			#Adding Bloom	
			var vertical_spread_angle = randf_range(-BLOOM, BLOOM)
			var vertical_spread_dir = Basis(global_transform.basis.x, vertical_spread_angle)

			var horizontal_spread_angle = randf_range(-BLOOM, BLOOM)
			var horizontal_spread_dir = Basis(global_transform.basis.y, horizontal_spread_angle)
			


			var base_dir = -global_transform.basis.z

			var result_dir = vertical_spread_dir * horizontal_spread_dir * base_dir


			projectile.look_at(global_transform.origin+result_dir, Vector3.UP)

			#var projectile_transform = global_transform
			#projectile_transform.rotated(Vector3.UP, randf_range(-BLOOM, BLOOM))
			
"""
TODO

Firing Sound Effect
Add bloom while firing

"""
	
