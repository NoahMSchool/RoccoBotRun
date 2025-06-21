extends Node

enum ItemLocation {
	NONE,
	LEFT, 
	RIGHT,
	BACK,
}
var item_locations = {
	ItemLocation.LEFT : PlayerItemLocation.new("Object/Items/EquippedItems/LeftHandItem", "left_action"),
	ItemLocation.RIGHT : PlayerItemLocation.new("Object/Items/EquippedItems/RightHandItem", "right_action")
}

var glow_materials = {
	"blue" : preload("res://Materials/blue_laser_mat.tres"), 
	"pink" : preload("res://Materials/pink_laser_mat.tres"),
	"red" : preload("res://Materials/red_laser_mat.tres"),
}
