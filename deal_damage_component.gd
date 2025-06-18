extends Component

class_name DealDamageComponent

@export var target_group = "enemies"

func deal_damage(damage, body):
	# Step 1: find the node that actually has the component
	var target : Node = body
	# If you collided with an Area3D under the enemy, move to its parent.
	# But we don’t hardcode Area3D; we just look for the component.
	while target and not target.has_node("DamagableComponent"):
		target = target.get_parent()
	if not target:
		return  # no damageable component found anywhere up the chain


	
	if target.is_in_group(target_group) and target.has_node("DamagableComponent"):
			target.damagable_component.get_damaged(damage)
