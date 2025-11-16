extends Area3D

@export var item : PackedScene
#Crashes if it is not an item that is added

func _ready() -> void:
	
	if item:
		if item.instantiate() is Item:
			var item_mesh = item.instantiate().find_child("MeshInstance3D")
			$MeshInstance3D.mesh = item_mesh.mesh
			$MeshInstance3D.material_override = item_mesh
		else:
			print("item Spawner does not conain item")
			
	
#Item probably shouldnt be telling player to pick it up
func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and body.has_method("add_item"):
		$CollectSound.play()
		body.add_item(item)
		set_process(false)
		visible = false


func _on_collect_sound_finished() -> void:
	queue_free()
