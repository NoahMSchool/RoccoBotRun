extends Weapon

const BLAST_PROJECTILE = preload("res://Scenes/WeaponScenes/plasma_blast.tscn")
const BLOOM = PI/72


func use_item(used_last):
	if $Timer.is_stopped() and ammo>0 and not used_last:
		$Timer.start(shot_time)
		$AudioStreamPlayer3D.play()
		
		#Adding projectile
		ammof -= 1
		var projectile = BLAST_PROJECTILE.instantiate()
		projectile.target_group = target_group
		projectile.accent_color = self.accent_color
		projectile.damage = damage
		$SpawnPoint.add_child(projectile)
		projectile.global_transform = global_transform
		
		projectile.global_transform = global_transform

		var base_dir = -global_transform.basis.z

		projectile.look_at(global_transform.origin+base_dir, Vector3.UP)
