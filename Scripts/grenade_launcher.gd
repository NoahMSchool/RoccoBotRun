extends Weapon

const GRENADE = preload("res://Scenes/WeaponScenes/grenade.tscn")
var power = 10
const ANGLE_SPEED = PI


var angle = 0.0:
	set(value):
		angle = clamp(value, 0, PI/3)
		rotation.x = angle
	get:
		return angle

var action = "left_action"
var action_pressed := false

var _last_call_time : int = 0

func use_item(used_last):
	var now = Time.get_ticks_msec()
	var dt_msec = now - _last_call_time
	var dt = dt_msec / 1000.0
	_last_call_time = now
	
	
	


func fire():
	print("grenade_fire")
	
func fire_released():
	pass




func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	if $Timer.is_stopped():
		if Input.is_action_just_released(action):
			$Timer.start(1)
			var grenade = GRENADE.instantiate()
			grenade.global_transform.origin = global_transform.origin
			grenade.accent_color = accent_color
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

Add preview of trajectory

"""
	
