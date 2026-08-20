extends Node

@onready var player_node : Node3D

var current_planet_num = 0

@onready var planet_container: Node3D = $PlanetContainer

var planets = [[preload("res://Environment/PlanetScenes/space_city.tscn"), null]
			]

func _ready() -> void:
	load_current_planet()

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

func instantiate_planet(planet_num):
	var new_planet = planets[planet_num][0].instantiate()
	planets[planet_num][1] = new_planet

func load_current_planet():
	if planets[current_planet_num][1] == null:
		instantiate_planet(current_planet_num)
	var planet_node = planets[current_planet_num][1]
	if planet_container.get_child_count()>0:
		planet_container.remove_child(planet_container.get_child(0))
	planet_container.add_child(planet_node)
	
