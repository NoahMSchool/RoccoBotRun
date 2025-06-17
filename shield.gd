extends Item

@export var damagable_component : DamagableComponent
@export var charge_component : ChargeComponent

func get_hit():
	print("hit")
	charge_component.reduce_charge()
	print(charge_component.charges)


#Add functionality to allow use item to place sheild forward
#Make configure Item Function place shield in pl
