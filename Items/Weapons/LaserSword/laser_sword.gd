extends Item

@onready var deal_damage_component = $DealDamageComponent
@onready var charge_component = $ChargeComponent
@export var target_group = "enemies"
@export var damage : float = 45

func use_item():
	if $ChargeComponent.charge>0:
		$AudioStreamPlayer3D.play()
		charge_component.reduce_charge()
		var range_bodies = $Area3D.get_overlapping_bodies()
		for body in range_bodies:
			deal_damage_component.deal_damage(damage, body)
