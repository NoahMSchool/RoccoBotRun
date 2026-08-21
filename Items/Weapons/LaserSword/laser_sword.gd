extends Item

@onready var deal_damage_component = $DealDamageComponent

@export var target_group = "enemies"
@export var damage : float = 45
@export var attack_cooldown = 0.25

func use_item():
	if $Timer.is_stopped() and can_use:
		can_use = false
		$Timer.start(attack_cooldown)
		$AudioStreamPlayer3D.play()
		var range_bodies = $Area3D.get_overlapping_bodies()
		for body in range_bodies:
			deal_damage_component.deal_damage(damage, body)

func release_item():
	can_use = true
