extends Item

const BLAST_PROJECTILE = preload("res://Items/Weapons/PlasmaCannon/plasma_blast.tscn")

@export var target_group = "enemies"
@export var fire_rate : float
@export var damage : int
@export var accent_color : String


@onready var shot_time = 1/fire_rate

func use_item():
	if $Timer.is_stopped() and $ChargeComponent.charge>0 and can_use:
		can_use = false
		$Timer.start(shot_time)
		$AudioStreamPlayer3D.play()
		
		#Adding projectile
		$ChargeComponent.reduce_charge()
		var projectile = BLAST_PROJECTILE.instantiate()
		projectile.target_group = target_group
		projectile.accent_color = self.accent_color
		projectile.damage = damage
		projectile.global_position = $SpawnPoint.global_position
		get_tree().current_scene.add_child(projectile)
		
		projectile.global_transform = global_transform

		var base_dir = -global_transform.basis.z

		projectile.look_at(global_transform.origin+base_dir, Vector3.UP)

func release_item():
	can_use = true


#Bug where cannon being unnequipped deletes projectile blast so make blast independant of the cannon
