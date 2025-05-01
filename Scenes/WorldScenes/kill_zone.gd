extends Area3D

@onready var game_manager = get_node("/root/Space/City/GameManager")

func _on_body_entered(body: Node3D) -> void:
	get_tree().game_manager.player_die()
