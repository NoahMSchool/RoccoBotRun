extends Component
class_name ChargeComponent

@export var max_charge : int
@export var charge_regen_rate : float
@onready var charge : int = max_charge
@onready var chargef : float = charge
@onready var cooldown_timer : Timer = $Timer

@export var regen_cooldown : float = 0.5
var can_regen : bool = true

#@export var charge_bar : ProgressBar
#should charge component know about its charge bar like health component does

func get_charge_percent() -> float:
	return chargef/max_charge

func regen_charge(delta : float) -> void:
	chargef = clamp(chargef+charge_regen_rate*delta,0,max_charge)
	charge = int(chargef)
	#print(get_parent())

func reduce_charge():
	chargef = clamp(chargef-1,0,max_charge)
	can_regen = false
	if cooldown_timer:
		cooldown_timer.stop()
		cooldown_timer.start(regen_cooldown)

func _physics_process(delta: float) -> void:
	if can_regen:
		regen_charge(delta*charge_regen_rate)
	charge = int(chargef)
	#print(chargef)

func _on_timer_timeout() -> void:
	can_regen = true
	pass
