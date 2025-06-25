extends Resource

class_name PlayerItemLocation

@export var node_path : NodePath
@export var use_action : String
@export var swap_action : String
@export var used_last : bool
@export var inventory_progress_bar_path : NodePath
@export var inventory_slot_path : NodePath

@export var rest_position : Vector3
@export var foreground_position : Vector3


func _init(_node_path_string : String, _use_action : String, _swap_action : String, _inventory_slot_path_string : String, _inventory_progress_bar_path_string : String, _rest_position : Vector3, _foreground_position : Vector3):
	node_path = NodePath(_node_path_string)
	use_action = _use_action
	swap_action = _swap_action
	used_last = false
	inventory_slot_path = NodePath(_inventory_slot_path_string)
	inventory_progress_bar_path = NodePath(_inventory_progress_bar_path_string)
	rest_position = _rest_position
	foreground_position = _foreground_position
