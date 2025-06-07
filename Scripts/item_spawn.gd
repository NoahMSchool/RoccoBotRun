extends Area3D

@export var item : PackedScene

func _ready() -> void:
	var item_mesh = item.instantiate().find_child("MeshInstance3D")
	$MeshInstance3D.mesh = item_mesh.mesh
	$MeshInstance3D.material_override = item_mesh
	
	
#Item probably shouldnt be telling player to pick it up
func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		$CollectSound.play()
		body.add_item(item)
		set_process(false)
		visible = false


func _on_collect_sound_finished() -> void:
	queue_free()
