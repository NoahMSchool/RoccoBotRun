extends Node

enum ItemLocation {
	LEFT, 
	RIGHT,
	BACK,
}

var materials = {
	"blue" : preload("res://Materials/blue_laser_mat.tres"), 
	"pink" : preload("res://Materials/pink_laser_mat.tres"),
	"red" : preload("res://Materials/red_laser_mat.tres"),
}

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("test") and event.is_pressed() and not event.is_echo():
	#auto_equip_items()
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
