extends Area3D

@export var item : PackedScene


func _on_body_entered(body: Node3D) -> void:
	print(body)
	if body.has_method("add_item") && item.is_class("weapon"):
		body.add_item(item)
	#if body.is_in_group("player"):
		#body.add_item()
		#print("intem granted")
