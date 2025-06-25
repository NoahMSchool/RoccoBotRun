extends Node3D
class_name Item

signal item_foregrounded(foreground : bool)

@export var icon : Texture
@export var can_hold_use : bool
var is_equipped : bool = false


func configure_item():
	#self.accent_color = "blue"
	#self.target_group = "enemies"
	pass
	
static func create_item(packed_scene: PackedScene)->Item:
	var item = packed_scene.instantiate()
	item.configure_item()
	return item

func set_equipped(is_equipped):
	set_enabled(is_equipped)

func set_enabled(is_enabled : bool):
	self.set_process(is_enabled)
	self.visible = is_enabled

func use_item(used_last):
	print("using_item")
