extends Item

@export var damagable_component : DamagableComponent
@export var charge_component : ChargeComponent

func _ready() -> void:
	damagable_component.get_hit.connect(get_hit)
	
func _physics_process(delta: float) -> void:
	#print(charge_component.charge)
	set_activation(charge_component.charge>0)
	


func get_hit():

	charge_component.reduce_charge()
	$AudioStreamPlayer3D.pitch_scale = lerp(0.4, 1.2, charge_component.chargef/charge_component.max_charge)
	$AudioStreamPlayer3D.play()
	if charge_component.charge == 0:
		$AudioStreamPlayer3D.play()
	print("get_hit()")
	
func set_activation(is_activated : bool) -> void:
	self.visible = is_activated
	self.set_enabled(is_activated)
	$Area3D/CollisionShape3D.disabled = not is_activated
	

#Add functionality to allow use item to place sheild forward, maybe have signal that is connected to player
#Make configure Item Function place shield in pl
