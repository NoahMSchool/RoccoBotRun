extends Node3D

class_name HealthComponent

signal health_out

@export var max_health : int = 150.0
var health = max_health
@export var health_bar : ProgressBar

func change_health(amount):
	health += amount
	health_bar.value = lerp(health_bar.min_value, health_bar.max_value, (health/max_health))

#make separate increase and decrease health funcitons

	if health <=0:
		emit_signal("health_out")
