extends AnimatableBody3D

@export var direction = Vector3(0,0,-1)
@export var distance = 5
@export var move_time = 2.5

@onready var start_position = position
@onready var time : float = 0.0

func _ready():
	var offset_time = randf_range(0,move_time)
	time = offset_time
func _physics_process(delta: float) -> void:
	time += delta
	var time_period = fmod(time,move_time*2)
	var cycle = time_period/move_time
	var offset = (sin(cycle*PI)+1)*distance
	position = start_position + offset * direction
