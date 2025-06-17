extends Component

class_name DealDamageComponent

@export var target_group = "enemies"

func deal_damage(damage, body):
	if body.is_in_group(target_group):
		body.has_node("DamagableComponent")
		if body.has_node("DamagableComponent"):
			body.damagable_component.get_damaged(damage)
