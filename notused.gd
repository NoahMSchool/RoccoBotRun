"""
#Camera Rotation Logic
func _process(delta: float) -> void:
	#controller look doesnt work
	var lx = Input.get_action_strength("right_joystick_right") - Input.get_action_strength("right_joystick_left")
	var ly = Input.get_action_strength("right_joystick_down") - Input.get_action_strength("right_joystick_up")
	
	$CamPivot.rotation.y += -lx * cam_sens*10000*delta
	$CamPivot.rotation.x += -ly * cam_sens*10000*delta
	$CamPivot.rotation.x = clamp($CamPivot.rotation.x, -PI/4, PI/8)

func _unhandled_input(event: InputEvent) -> void:
	
	if event is InputEventMouseMotion:
		$CamPivot.rotation.y -= event.relative.x*cam_sens
		$CamPivot.rotation.x -= event.relative.y*cam_sens
		$CamPivot.rotation.x = clamp($CamPivot.rotation.x, -PI/4, PI/8)
	
	
	#$CamPivot.rotate_y(-lx * cam_sens*100)
	#$CamPivot.rotate_x(-ly * cam_sens*100)
"""
