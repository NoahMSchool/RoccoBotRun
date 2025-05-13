extends Area3D

@export var item : PackedScene


func _on_body_entered(body: Node3D) -> void:
	print(body)
	if body.is_in_group("player"):
		print("intem granted")
