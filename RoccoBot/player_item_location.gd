extends Resource

class_name PlayerItemLocation

@export var node_path : NodePath
@export var use_action : String
@export var swap_action : String
@export var used_last : bool
@export var inventory_progress_bar_path : NodePath
@export var inventory_slot_path : NodePath
@export var anim_filter_name : String

@export var upper_limb_look : String
@export var lower_limb_look : String

@export var targeting_IK_path : NodePath

func _init(_node_path_string : String, _use_action : String, _swap_action : String, _inventory_slot_path_string : String, _inventory_progress_bar_path_string : String, _targeting_IK_path : String, _anim_filter_name : String, _upper_limb_look = "", _lower_limb_look = ""):
	node_path = NodePath(_node_path_string)
	use_action = _use_action
	swap_action = _swap_action
	used_last = false
	inventory_slot_path = NodePath(_inventory_slot_path_string)
	inventory_progress_bar_path = NodePath(_inventory_progress_bar_path_string)
	targeting_IK_path = NodePath(_targeting_IK_path)
	anim_filter_name = _anim_filter_name
	upper_limb_look = _upper_limb_look
	lower_limb_look = _lower_limb_look
