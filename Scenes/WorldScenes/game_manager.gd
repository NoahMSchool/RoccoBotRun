extends Node

signal reset_level

var stage_num = 0

var stage = [$"../Stages/Stage1", ]

func player_die():
	print("die")
	emit_signal("reset_level")

func stage_reached():
	for node in stage[stage_num]:
		stage_num +=1
