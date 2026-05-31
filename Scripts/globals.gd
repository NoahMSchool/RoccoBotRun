extends Node

var teams = {
	"neutral" : Team.new("neutral", "white"),
	"player" : Team.new("player", "blue"),
	"enemy_robot" : Team.new("enemies", "red"),	
}
func get_team(team_string):
	var team = Globals.teams.get(team_string, Globals.teams["neutral"])
	if team == Globals.teams["neutral"] and team_string != "neutral":
		print("Invalid Team used, set to neutral")
		push_warning("%s tried to use invalid team '%s', defaulting to neutral")
	return team


var glow_materials = {
	"blue" : preload("res://Materials/blue_laser_mat.tres"), 
	"pink" : preload("res://Materials/pink_laser_mat.tres"),
	"red" : preload("res://Materials/red_laser_mat.tres"),
}
