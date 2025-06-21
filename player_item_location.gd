extends Resource

class_name PlayerItemLocation


@export var node_path : NodePath
@export var use_action : String
@export var used_last : bool

func _init(_node_path_string, _use_action):
	node_path = NodePath(_node_path_string)
	use_action = _use_action
	used_last = false
