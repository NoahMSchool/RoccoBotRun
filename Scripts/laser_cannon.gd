extends Item

const LASER_PROJECTILE = preload("res://Scenes/WeaponScenes/laser_projectile.tscn")
const BLOOM = PI/72

@onready var charge_component = $ChargeComponent
@export var target_group = "enemies"
@export var fire_rate : float
@export var damage : int
@export var accent_color : String


@onready var shot_time = 1/fire_rate
#use shoot component maybe

func configure_item():
	self.accent_color = "blue"
	

func use_item(used_last):
	if $Timer.is_stopped() and $ChargeComponent.charge>0:
		$Timer.start(shot_time)
		$AudioStreamPlayer3D.pitch_scale = lerp(0.9, 1.1, charge_component.chargef/charge_component.max_charge)
		$AudioStreamPlayer3D.play()
		
		#Adding projectile
		$ChargeComponent.reduce_charge()
		var projectile = LASER_PROJECTILE.instantiate()
		projectile.target_group = target_group
		projectile.accent_color = self.accent_color
		projectile.damage = damage
		add_child(projectile)
		projectile.global_transform = global_transform
		#Adding Bloom	
		var vertical_spread_angle = randf_range(-BLOOM, BLOOM)
		var vertical_spread_dir = Basis(global_transform.basis.x, vertical_spread_angle)

		var horizontal_spread_angle = randf_range(-BLOOM, BLOOM)
		var horizontal_spread_dir = Basis(global_transform.basis.y, horizontal_spread_angle)
		


		var base_dir = -global_transform.basis.z

		var result_dir = vertical_spread_dir * horizontal_spread_dir * base_dir

		projectile.look_at(global_transform.origin+result_dir, Vector3.UP)
