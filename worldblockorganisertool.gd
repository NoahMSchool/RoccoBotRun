@tool
extends Node3D

@export var trigger : bool = false:
	set(value):
		generate_mesh_library()
		trigger = false
@export var file_name = "worldblocks"
var file_path = "res://Environment/"

func compare_block_names_decending(a,b):
	print(a.name < b.name)
	if a.name < b.name:
		return true
	return false


func update_blocks():
	var reference_blocks = $Referenceblocks
	print("__________starting_update__________")
	
	for c in get_children():
		if c != reference_blocks:
			#print("deleting",c.name)
			c.free()

	var block_array = reference_blocks.get_children()
	#block_array.sort_custom(compare_block_names_decending)
	block_array.sort_custom(func(a, b): return a.name.naturalnocasecmp_to(b.name) < 0)
	
	for i in range(block_array.size()-1):
		var block = block_array[i]
		var block_id = block.name.left(3)
		var new_mesh = MeshInstance3D.new()
		new_mesh.mesh = block.mesh.duplicate()
		new_mesh.name = block.name
		var new_static_body = StaticBody3D.new()
		var new_collision = CollisionShape3D.new()
		new_collision.shape = block.get_child(0).get_child(0).shape
		new_static_body.add_child(new_collision)
		new_mesh.add_child(new_static_body)
		new_mesh.position = block.position# + Vector3.UP*2

		add_child(new_mesh)
		new_static_body.set_owner(get_tree().edited_scene_root)
		new_collision.set_owner(get_tree().edited_scene_root)
		new_mesh.set_owner(get_tree().edited_scene_root)
		
		print(new_mesh)
		print(i)
		new_mesh.set_meta("mesh_library_item/id", i)
		print(new_mesh.get_meta("mesh_library_item/id")) 
				
	print("__________finished_update__________")

func generate_mesh_library():
	var library = MeshLibrary.new()
	var reference_blocks = $Referenceblocks
	print("__________started_generation__________")

	var block_array = reference_blocks.get_children()
	block_array.sort_custom(func(a, b): return a.name.naturalnocasecmp_to(b.name) < 0)
	print(block_array)
	for i in range(block_array.size()):
		var block_ref : MeshInstance3D = block_array[i]
		var block_id = block_ref.name.left(3)
		var block_name = block_ref.name
		var block_mesh : Mesh = block_ref.mesh
		var block_material = block_ref.get_active_material(0).duplicate() # block_ref.mesh.surface_get_material(0).duplicate()
		
		#print(block_material)
		#block_mesh.surface_set_material(0, block_material)
		var block_col_shape = block_ref.get_child(0).get_child(0).shape
		
		var surface_tool  := SurfaceTool.new()
		surface_tool.append_from(block_mesh, 0, Transform3D())
		surface_tool.set_material(block_material)
		var new_mesh: ArrayMesh = surface_tool.commit()
		
		#var new_mesh: Mesh = block_mesh.duplicate()
		new_mesh.surface_set_material(0, block_material)
		
		library.create_item(i)
		library.set_item_name(i, block_name)
		library.set_item_mesh(i, new_mesh)
		#print(library.get_item_mesh(i))
		library.set_item_shapes(i, [block_col_shape, Transform3D()])
	var library_export_path = file_path+file_name+".res"
	#var library_export_path = "res://Environment/world_blocks3.res"
	var error = ResourceSaver.save(library, library_export_path)#, ResourceSaver.FLAG_BUNDLE_RESOURCES
	print(error == 0)
	
	print("__________finished_generaton__________")
	
