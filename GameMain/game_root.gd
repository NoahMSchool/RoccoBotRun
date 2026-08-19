extends Node

@onready var player_node : Node3D
@onready var current_planet : PlanetWorld = $SpaceCity

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("FreeMouse"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if event.is_action_pressed("plus"):
		pass

	if event.is_action_pressed("test") and event.is_pressed() and not event.is_echo():
		pass
	
		pass
	
	if event.is_action_pressed("test2") and event.is_pressed() and not event.is_echo():
		#$RoccoBot.add_item(laser_scene)
		pass
		
	if event.is_action_pressed("test3") and event.is_pressed() and not event.is_echo():
		#for item_location in Globals.ItemLocation.values():
			#print(item_location, typeof(item_location))
			#$RoccoBot.unequip_item(item_location)
		pass
		
	if event.is_action_pressed("quit") and event.is_pressed() and not event.is_echo():
		get_tree().quit()
