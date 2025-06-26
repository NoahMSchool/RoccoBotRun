extends Item

const GRENADE = preload("res://Items/Weapons/GrenadeLauncher/grenade.tscn")
var power = 10
const ANGLE_SPEED = PI

@export var throw_cooldown : float = 1
@export var damage : int = 150
@export var accent_color : String

var rising : bool
var angle = 0.0
var action = "left_action"
var action_pressed := false

var time_since_last_release : float = 0

func use_item():
	#if $Timer.is_stopped():
		rising = true
	

func release_item():
	rising = false
	if $Timer.is_stopped() and $ChargeComponent.charge>0:
		$ChargeComponent.reduce_charge()
		$Timer.start(throw_cooldown)
		var grenade = GRENADE.instantiate()
		grenade.global_transform.origin = global_transform.origin
		grenade.damage = damage
		grenade.accent_color = accent_color
		var direction = -global_transform.basis.z
		var impulse = direction * power
		
		add_child(grenade)
		#get_tree().current_scene.add_child(grenade)
		grenade.launch(impulse)
		time_since_last_release = 0

func _physics_process(delta: float) -> void:
	time_since_last_release +=delta
	if rising:
		angle = clampf(move_toward(angle, PI/3, delta),0,PI/3)
	else:
		angle = clampf(move_toward(angle, 0, delta), 0,PI/3)

	rotation.x = angle

"""
TODO
Contain grenade and its explosion to one scene
Add preview of trajectory

"""
	
