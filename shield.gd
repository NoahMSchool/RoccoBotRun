extends Item

@export var damagable_component : DamagableComponent
@export var charge_component : ChargeComponent


func get_hit():
	charge_component.reduce_charge()
