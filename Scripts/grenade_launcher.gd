extends Node3D

const GRENADE = preload("res://WeaponScenes/grenade.tscn")
var power = 10
const ANGLE_SPEED = PI
var angle = 0.0:
	set(value):
		angle = clamp(value, 0, PI/3)
		rotation.x = angle
	get:
		return angle

var action = "left_action"

func _physics_process(delta: float) -> void:
	if $Timer.is_stopped():
		if Input.is_action_just_released(action):
			$Timer.start(1)
			var grenade = GRENADE.instantiate()
			grenade.global_transform.origin = global_transform.origin
			var direction = -global_transform.basis.z
			var impulse = direction * power
			
			add_child(grenade)
			#get_tree().current_scene.add_child(grenade)
			grenade.launch(impulse)
		
		elif Input.is_action_pressed(action):
			angle+= ANGLE_SPEED*delta
			
		else:
			angle = move_toward(angle, 0 , ANGLE_SPEED*delta)

"""
TODO

Make grenade launch on release and angle of launch based on hold time

Add preview of trajectory

"""
	
