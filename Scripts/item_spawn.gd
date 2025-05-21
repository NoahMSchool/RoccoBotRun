extends Area3D

@export var item : PackedScene


func _on_body_entered(body: Node3D) -> void:
	print(body)
	if body.is_in_group("player"):
		print("adding_item")
		body.add_item(item)
	queue_free()
