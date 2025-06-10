extends Node3D
class_name Item

@export var icon : Texture

static func create_item(packed_scene: PackedScene)->Item:
	var item = packed_scene.instantiate()
	item.configure_item()
	return item

func configure_item():
	pass
	
func set_enabled(is_enabled : bool):
	self.set_process(is_enabled)
	self.visible = is_enabled
