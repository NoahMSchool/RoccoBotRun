extends Item

func use_item():
	if can_use:
		$AudioStreamPlayer3D.play()
		can_use = false
	
func release_item():
	can_use = true
