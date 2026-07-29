@tool
extends EditorScript

var mat = preload("res://RoccoBot/RoccoBot_Metal_material.tres")
var continer_path = "Character"

func _run() -> void:
	var scene = get_scene()
	print(scene)
	var container = scene.get_node_or_null("Character/RoccoBotRig/Skeleton3D")
	
	var children = container.get_children()
	
	for child in children:
		if child is MeshInstance3D:
			print(child)
			var surface_count = child.get_surface_override_material_count()
			print(surface_count)
			range(surface_count)
			print(mat)
			print(range(surface_count))
			for i in range(surface_count-1): 
				child.set_surface_override_material(i, mat)
