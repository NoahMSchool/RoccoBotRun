extends Node

enum ItemLocation {
	NONE,
	LEFT, 
	RIGHT,
	BACK,
}

var glow_materials = {
	"blue" : preload("res://Materials/blue_laser_mat.tres"), 
	"pink" : preload("res://Materials/pink_laser_mat.tres"),
	"red" : preload("res://Materials/red_laser_mat.tres"),
}
