extends Node3D
class_name ChargeComponent

@export var max_charge : int
@export var charge_regen_rate : float
@onready var charge = max_charge
@onready var chargef = charge

func get_charge_percent() -> float:
	return chargef/max_charge

func regen_charge(delta : float) -> void:
	chargef = clamp(chargef+charge_regen_rate*delta,0,max_charge)
	charge = int(chargef)

func reduce_charge():
	charge -= 1
