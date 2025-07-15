extends Item

const LASER_PROJECTILE = preload("res://Items/Weapons/LaserCannon/laser_projectile.tscn")
const BLOOM = PI/72

@onready var charge_component = $ChargeComponent
@onready var shoot_component = $ShootComponent

@export var target_group = "enemies"
@export var fire_rate : float
@export var damage : float = 30
@export var accent_color : String


@onready var shot_time = 1/fire_rate

func configure_item():
	self.accent_color = "blue"

func _ready() -> void:
	shoot_component.projectile = LASER_PROJECTILE
	shoot_component.target_group = target_group
	shoot_component.bloom_angle = BLOOM
	shoot_component.damage = damage
	shoot_component.accent_color = accent_color

func use_item():
	if $Timer.is_stopped() and $ChargeComponent.charge>0:
		$Timer.start(shot_time)
		#$AudioStreamPlayer3D.pitch_scale = lerp(0.9, 1.1, charge_component.chargef/charge_component.max_charge)
		$AudioStreamPlayer3D.play()
		
		#Adding projectile
		$ChargeComponent.reduce_charge()
		$ShootComponent.shoot(global_transform)
