@tool
extends Node3D

@export var trigger : bool = false:
	set(value):
		generate_mesh_library()
		trigger = false


func generate_mesh_library():
	var collection_name := "SpaceCityBlocks"
	var file_name = "spacecityblocks8"
	var file_path = "res://Environment/GridMapMeshLibraries/"
	var color_tex_path = "res://Environment/GridMapMaterialAtlases/SpaceCityBlocks_color_atlas4.png"
	var roughness_tex_path = "res://Environment/GridMapMaterialAtlases/SpaceCityBlocks_normal_atlas0.png"
	var roughness_tex_scale = 0.5
	var normal_tex_path = "res://Environment/GridMapMaterialAtlases/SpaceCityBlocks_roughness_atlas1.png"
	var normal_tex_scale = 0

	var library = MeshLibrary.new()
	#var reference_blocks = $Referenceblocks
	
	var collection_continer = get_node_or_null("Referenceblocks/"+collection_name)
	if collection_continer:
		print("__________started_generation__________")

		var block_array = collection_continer.get_children()
		
		block_array.sort_custom(func(a, b): return a.get_meta("mesh_lib_id") < b.get_meta("mesh_lib_id"))

		print(block_array)
		for i in range(block_array.size()):
			var block_ref = block_array[i]
			var block_name = block_ref.name
			var block_mesh : Mesh = block_ref.mesh
			var block_material = StandardMaterial3D.new()
			block_material.albedo_texture = load(color_tex_path)
			block_material.roughness_texture = load(roughness_tex_path)
			block_material.rougness = roughness_tex_scale
			block_material.normal_enabled = true
			block_material.normal_texture = load(normal_tex_path)
			block_material.normal_scale = normal_tex_scale
			#block_ref.get_active_material(0).duplicate() # block_ref.mesh.surface_get_material(0).duplicate()
			
			#print(block_material)
			#block_mesh.surface_set_material(0, block_material)
			var surface_tool  := SurfaceTool.new()
			surface_tool.append_from(block_mesh, 0, Transform3D())
			surface_tool.set_material(block_material)
			var new_mesh: ArrayMesh = surface_tool.commit()
			
			#var new_mesh: Mesh = block_mesh.duplicate()
			new_mesh.surface_set_material(0, block_material)
			
			library.create_item(i)
			library.set_item_name(i, block_name)
			library.set_item_mesh(i, new_mesh)

			if block_ref.get_child_count()>0: #check if block has collision shape, if so add it
				var block_static_body = block_ref.get_child(0)
				var block_col_shape = block_static_body.get_child(0).shape
				library.set_item_shapes(i, [block_col_shape, Transform3D()])
		
		var library_export_path = file_path+file_name+".res"
		var error = ResourceSaver.save(library, library_export_path)#, ResourceSaver.FLAG_BUNDLE_RESOURCES
		print(error == 0)
		
		print("__________finished_generaton__________")
	else:
		print("couldnt find collection node")
