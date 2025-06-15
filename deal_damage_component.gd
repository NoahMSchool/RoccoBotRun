extends Node3D

class_name DealDamageComponent


func deal_damage(damage, body):
	print(body.has_node("DamagableComponent"))
	if body.has_node("DamagableComponent"):
		body.damagable_component.get_damaged(damage)

#not safe
