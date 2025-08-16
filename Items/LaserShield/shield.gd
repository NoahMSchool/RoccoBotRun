extends Item

@export var damagable_component : DamagableComponent
@export var charge_component : ChargeComponent

@export var max_charge : int = 8
@export var regen_rate : float = 0.5
@export var regen_cooldown : float = 2

#var activated = false:
#	set(value):
		#activated = value
		#$MeshInstance3D.visible = value
		#$Area3D/CollisionShape3D.disabled = not value


func _ready() -> void:
	damagable_component.get_hit.connect(get_hit)
	
	charge_component.max_charge = max_charge
	charge_component.charge_regen_rate = regen_rate
	charge_component.regen_cooldown = regen_cooldown
	
	set_activation(false)
	var parent = get_parent()
	#if parent:

func use_item():
	if charge_component.charge>0:
		set_activation(true)
	else:
		set_activation(false)

func release_item():
	set_activation(false)
	
func get_hit():
	charge_component.reduce_charge()
	$AudioStreamPlayer3D.pitch_scale = lerp(0.4, 1.2, charge_component._chargef/charge_component.max_charge)
	$AudioStreamPlayer3D.play()
	if charge_component.charge == 0:
		$AudioStreamPlayer3D.play()
	
func set_activation(is_activated : bool) -> void:
	$MeshInstance3D.visible = is_activated
	$Area3D/CollisionShape3D.disabled = not is_activated
	
