extends Node3D

@export var tail_speed = 2.5

@onready var rest_target = $"../TailRestTarget"
@onready var rocco_bot: CharacterBody3D = $"../.."

func _ready() -> void:
	global_position = rest_target.global_position
	
@onready var cycle = 0
func _process(delta: float) -> void:
	cycle = fmod(cycle+delta*2, PI*2)
	
	var old_pos = global_position
	
	global_position.x = lerpf(old_pos.x, rest_target.global_position.x, delta*tail_speed)
	global_position.y = lerpf(old_pos.y, rest_target.global_position.y, delta*tail_speed)
	global_position.z = lerpf(old_pos.z, rest_target.global_position.z, delta*tail_speed)
	
	global_position += 0.0025*sin(cycle) * (rocco_bot.transform.basis.x.normalized())
	global_position.y += 0.001*cos(cycle)
	
	look_at(old_pos)
