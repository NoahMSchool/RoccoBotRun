extends Component
class_name ChargeComponent

@onready var cooldown_timer : Timer = $Timer

var charge : int
var _chargef : float = charge:
	get:
		return _chargef
	set(value):
		_chargef = value
		charge = int(_chargef)
		
		
	

#attributes
var max_charge : int
var charge_regen_rate : float
var regen_cooldown : float = 0.5
var can_regen : bool = true
var start_full : bool = true

func _ready() -> void:
	if start_full:
		call_deferred("set_max_charge")
func set_max_charge():
	_chargef = max_charge
		
#@export var charge_bar : ProgressBar
#should charge component know about its charge bar like health component does

func get_charge_percent() -> float:
	return _chargef/max_charge

func regen_charge(delta : float) -> void:
	_chargef = clamp(_chargef+charge_regen_rate*delta,0,max_charge)
	#print(get_parent())

func reduce_charge():
	_chargef = clamp(_chargef-1,0,max_charge)
	can_regen = false
	if cooldown_timer:
		cooldown_timer.stop()
		cooldown_timer.start(regen_cooldown)

func _physics_process(delta: float) -> void:
	if can_regen:
		regen_charge(delta*charge_regen_rate)
	charge = int(_chargef)
	#print(chargef)

func _on_timer_timeout() -> void:
	can_regen = true
	pass
