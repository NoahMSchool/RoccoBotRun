extends Component
class_name ChargeComponent

@export var max_charge : int
@export var charge_regen_rate : float
@onready var charge : int = max_charge
@onready var chargef : float = charge

@export var health_bar : ProgressBar


func get_charge_percent() -> float:
	return chargef/max_charge

func regen_charge(delta : float) -> void:
	chargef = clamp(chargef+charge_regen_rate*delta,0,max_charge)
	charge = int(chargef)

func reduce_charge():
	chargef = clamp(chargef-1,0,max_charge)
	


func _physics_process(delta: float) -> void:
	regen_charge(delta*charge_regen_rate)
