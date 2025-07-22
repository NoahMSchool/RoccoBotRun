extends Item

@export var damagable_component : DamagableComponent
@export var charge_component : ChargeComponent

func _ready() -> void:
	damagable_component.get_hit.connect(get_hit)
	
	var parent = get_parent()
	#if parent:
		

func _physics_process(delta: float) -> void:
	#print(charge_component.charge)
	set_activation(charge_component.charge>0)

func use_item():
	item_foregrounded.emit(true)

func release_item():
	item_foregrounded.emit(false)
	
func get_hit():
	charge_component.reduce_charge()
	$AudioStreamPlayer3D.pitch_scale = lerp(0.4, 1.2, charge_component._chargef/charge_component.max_charge)
	$AudioStreamPlayer3D.play()
	if charge_component.charge == 0:
		$AudioStreamPlayer3D.play()
	
func set_activation(is_activated : bool) -> void:
	$MeshInstance3D.visible = is_activated
	$Area3D/CollisionShape3D.disabled = not is_activated
	

#Add functionality to allow use item to place sheild forward, maybe have signal that is connected to player
#Make configure Item Function place shield in pl
