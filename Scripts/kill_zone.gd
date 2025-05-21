extends Area3D

@onready var game_manager = $"../GameManager"

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		game_manager.player_die()
