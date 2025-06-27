extends Component

class_name HealthComponent

signal health_out

@export var max_health : int = 150.0
@export var health_bar : ProgressBar
var health = max_health

func change_health(amount):
	health += amount
	if health_bar:
		health_bar.value = lerp(health_bar.min_value, health_bar.max_value, (health/max_health))

#make separate increase and decrease health funcitons

	if health <=0:
		emit_signal("health_out")
