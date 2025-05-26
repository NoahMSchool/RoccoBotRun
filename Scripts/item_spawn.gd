extends Area3D

@export var item : PackedScene

#Item probably shouldnt be telling player to pick it up
func _on_body_entered(body: Node3D) -> void:
	print(body)
	if body.is_in_group("player"):
		$CollectSound.play()
		print("adding_item")
		body.add_item(item)
		set_process(false)
		visible = false


func _on_collect_sound_finished() -> void:
	queue_free()
