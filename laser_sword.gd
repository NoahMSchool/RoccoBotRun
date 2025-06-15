extends Weapon

func use_item(used_last):
	if not used_last:
		if $Timer.is_stopped():
			$AudioStreamPlayer3D.play()
			var range_bodies = $Area3D.get_overlapping_bodies()
			for body in range_bodies:
				if body.is_in_group(target_group):
					body.queue_free()
			$Timer.start()
