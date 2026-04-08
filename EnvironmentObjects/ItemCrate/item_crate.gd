extends StaticBody3D


@export var crate_type : CrateType
@export var dissapear_on_use := false

const item_loose = preload("res://EnvironmentObjects/ItemSpawns/item_loose.tscn")


var items : Array[PackedScene] = [preload("res://Items/Weapons/GrenadeLauncher/grenade_launcher.tscn")]

func _ready() -> void:
	config_crate()
	
func config_crate():
	if crate_type:
		if crate_type.box_mesh:
			$BoxPiv/BoxMesh.mesh = crate_type.box_mesh
			if crate_type.box_mat:
				$BoxPiv/BoxMesh.material_override = crate_type.box_mat
		if crate_type.cap_mesh:
			$LidPiv/CapMesh.mesh = crate_type.cap_mesh
			if crate_type.cap_mat:
				$LidPiv/CapMesh.material_override = crate_type.box_mat
		
		if crate_type.flip_mesh:
			$LidPiv/CapMesh.rotation.y = PI
			$BoxPiv/BoxMesh.rotation.y = PI
		if crate_type.mesh_scale_overide:
			$BoxPiv/BoxMesh.scale *= crate_type.mesh_scale_overide
			$LidPiv/CapMesh.scale *= crate_type.mesh_scale_overide
			
		if crate_type.box_offset:
			$BoxPiv.position = crate_type.box_offset
		if crate_type.lid_offset:
			$LidPiv.position = crate_type.lid_offset
		
		if crate_type.mesh_scale_overide:
			#$CollisionShape3D.shape = shape to fit
			pass

func interact():
	
	open()
	if dissapear_on_use:
			queue_free()

func open():
	if crate_type:
		if crate_type.open_sound:
			$AudioStreamPlayer3D.stream = crate_type.open_sound
			$AudioStreamPlayer3D.play()
	var open_tween = create_tween()
	open_tween.tween_property($LidPiv, "rotation", Vector3(PI/4,0,0), 1.0)
	#open_tween.tween_property($LidPiv, "position", Vector3(0,0.5,0), 1.0)
	var new_loose = item_loose.instantiate()
	new_loose.item = items[0]
	new_loose.global_position = global_position + Vector3(0,0,crate_type.place_infront_distance)
	get_tree().get_root().add_child(new_loose)


func _on_selection_range_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		body.add_interactable(self)
		print("added")

func _on_selection_range_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		body.remove_interactable(self)
		print("removed")
