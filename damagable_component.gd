extends Node3D
class_name DamagableComponent

@export var health_component : HealthComponent = null

func get_damaged(damage):
	if health_component:
		health_component.change_health(-damage)
	
	if get_parent().has_method("get_hit"):
		get_parent().get_hit("damage")
