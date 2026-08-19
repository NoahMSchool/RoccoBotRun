extends Node
class_name PlanetWorld

@onready var player_node : Node3D

func _ready() -> void:
	print("hi")
	player_node = get_tree().get_root().get_node("GameRoot/RoccoBot")
	#player_node.died.connect(player_die) 
	player_node.connect("died", player_die)
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Die"):
		player_die()
	
func player_die():
	print("player died")
	
	
func reset_level():
	pass
	
