extends Item

const GRENADE = preload("res://Items/Weapons/GrenadeLauncher/grenade.tscn")
var power = 10
const ANGLE_SPEED = PI

@export var throw_cooldown : float = 1
@export var damage : int = 150
@export var accent_color : String

@onready var charge_component = $ChargeComponent
@onready var shoot_component = $ShootComponent

var rising : bool
var angle = 0.0
var action = "left_action"
var action_pressed := false

var time_since_last_release : float = 0

func _ready() -> void:
	shoot_component.projectile = GRENADE
	shoot_component.damage = damage
	shoot_component.accent_color = accent_color
	
	
func use_item():
	#if $Timer.is_stopped():
		rising = true
	

func release_item():
	rising = false
	if $Timer.is_stopped() and charge_component.charge>=1:
		charge_component.reduce_charge()
		$Timer.start(throw_cooldown)
		var grenade = shoot_component.shoot(global_transform)
		var direction = -global_transform.basis.z
		var impulse = direction * power
		grenade.launch(impulse)
		time_since_last_release = 0
	elif charge_component.charge<1:
		item_used.emit()
		

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
	
