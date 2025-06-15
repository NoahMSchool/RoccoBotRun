extends Item


func use_item(used_last):
	print(used_last)
	if not used_last:
		$AudioStreamPlayer3D.play()
