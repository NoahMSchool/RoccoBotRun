extends StaticBody3D


@export var crate_type : Resource
@export var dissapear_on_use := true

var place_infront_distance = 0.5

const item_loose = preload("res://EnvironmentObjects/ItemSpawns/item_loose.tscn")


var items : Array[PackedScene] = [preload("res://Items/Weapons/GrenadeLauncher/grenade_launcher.tscn")]

func _ready() -> void:
	# set parameters
	pass

func open():
	var new_loose = item_loose.instantiate()
	new_loose.item = items[0]
	new_loose.global_position = global_position + Vector3(0,0,-place_infront_distance)
	get_tree().get_root().add_child(new_loose)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("plus"):
		open()
		if dissapear_on_use:
			queue_free()
