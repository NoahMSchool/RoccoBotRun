extends Node3D
class_name Item

#var packed_scene : PackedScene

static func create_item(packed_scene: PackedScene)->Item:
	var item = packed_scene.instantiate()
	item.configure_item()
	return item

func configure_item():
	if self is Weapon:
		self.accent_color = "blue"
		#self.target_group = "enemies"

func set_enabled(is_enabled : bool):
	self.set_process(is_enabled)
	self.visible = is_enabled
	print(is_enabled)

func fire():
	print("fire")
