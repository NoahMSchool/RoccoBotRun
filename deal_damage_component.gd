extends Component

class_name DealDamageComponent

@export var target_group = "enemies"

func deal_damage(damage, body):
	var target : Node = body
	while target and not target.has_node("DamagableComponent"):
		target = target.get_parent()
	if target:
		if target.is_in_group(target_group) and target.has_node("DamagableComponent"):
				target.damagable_component.get_damaged(damage)
