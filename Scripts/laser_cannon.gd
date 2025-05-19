extends Weapon

const LASER_PROJECTILE = preload("res://Scenes/WeaponScenes/laser_projectile.tscn")
const BLOOM = PI/72


func fire():
	if $Timer.is_stopped() and ammo>0:
		$Timer.start(0.2)
		$AudioStreamPlayer3D.play()
		
		#Adding projectile
		ammof -= 1
		var projectile = LASER_PROJECTILE.instantiate()
		projectile.target_group = target_group
		projectile.accent_color = self.accent_color
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
