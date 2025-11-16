extends StaticBody3D


@export var crate_type : Resource
@export var dissapear_on_use := true

var place_infront_distance = 0.5

const item_loose = preload("res://EnvironmentObjects/ItemSpawns/item_spawn.tscn")

func _ready() -> void:
	# set parameters
	pass

func open():
	
