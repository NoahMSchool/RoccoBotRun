extends Node

signal reset_level

@export var stage_node : Node
var stage_num : int = 0
@onready var stages = stage_node.get_children()
@export var player_node : CharacterBody3D


func player_die():
	print("die")
	emit_signal("reset_level")

func stage_reached():
	for node in stages[stage_num]:
		stage_num +=1

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("plus"):
		stage_num = (stage_num+1) % (stages.size())
		change_stage()
		
	if event.is_action_pressed("minus"):
		stage_num = absi((stage_num-1) % (stages.size()))
		change_stage()
	if event.is_action_pressed("FreeMouse"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if event.is_action_pressed("Die"):
		player_die()
		
func change_stage():
	print(stage_num)
	print(stages[stage_num].name)
	for i in range(stages.size()):
		var stage_object = stages[i].get_node("StageObjects")
		if stage_object:
			stage_object.visible = (i == stage_num)
		
	var spawn_object = stages[stage_num].get_node("CheckPointSpawn")
		#spawn_object.visible = (i == stage_num)
	if spawn_object && player_node:
		player_node.spawnpoint = spawn_object
		


func _on_check_point_spawn_checkpoint_reached(checkpoint: Node3D) -> void:
	print(checkpoint)
