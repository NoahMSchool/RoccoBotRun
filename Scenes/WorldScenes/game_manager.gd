extends Node

signal reset_level

func player_die():
	print("die")
	emit_signal("reset_level")
