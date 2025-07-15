extends Node3D
class_name Item

signal item_foregrounded(foreground : bool)
signal item_used

@export var icon : Texture
var is_equipped : bool = false
var can_use = true

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

func use_item():
	#print("using_item")
	pass

func release_item():
	#print("releasing_item")
	pass
