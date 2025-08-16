extends Resource

class_name Team

@export var accent_color : String
@export var group : String

func _init(_group, _accent_color) -> void:
	accent_color = _accent_color
	group = _group
