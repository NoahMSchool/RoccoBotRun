extends Component

class_name HealthComponent

signal health_out

@export var max_health : float = 150.0
@export var health_bar : ProgressBar
var health = max_health

func change_health(amount):
	health += amount
	if health_bar:
		print(health, health/max_health)
		print(type_string(typeof(health)), type_string(typeof(max_health)), type_string(typeof(health/max_health)))
		health_bar.value = lerpf(health_bar.min_value, health_bar.max_value, health/max_health)
		print("healthbarvalue", lerpf(health_bar.min_value, health_bar.max_value, health/max_health))
		print("min", health_bar.min_value, "max", health_bar.max_value, "current", health_bar.value)

	if health <=0:
		emit_signal("health_out")

#make separate increase and decrease health funcitons
