extends Component
class_name DamagableComponent

signal get_hit

@export var health_component : HealthComponent = null

func get_damaged(damage):
	print(health_component)
	if health_component:
		health_component.change_health(-damage)
		print("hl")
	emit_signal("get_hit")
