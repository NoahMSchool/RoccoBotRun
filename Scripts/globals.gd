extends Node

var player_item_locations = [
							#"Object/Items/EquippedItems/LeftHandItem" Vector3(-0.75,0.15,-0.25), Vector3(-0.45,0.15,-0.75)
							#"Object/Items/EquippedItems/RightHandItem" Vector3(0.75,0.15,-0.25), Vector3(0.45,0.15,-0.75)
							PlayerItemLocation.new("Object/Skeleton3D/LeftItemAttatch/LeftItemLocation", "left_action", "swap_left_action", "Control/Inventory/EquippedItems/LeftItemSlot", "Control/Inventory/EquippedItems/LeftItemSlot/LeftAmmoIndicator", "Object/Skeleton3D/LeftAimIK"),
							PlayerItemLocation.new("Object/Skeleton3D/RightItemAttatch/RightItemLocation", "right_action", "swap_right_action","Control/Inventory/EquippedItems/RightItemSlot", "Control/Inventory/EquippedItems/RightItemSlot/LeftAmmoIndicator", "Object/Skeleton3D/RightAimIK"), 
							]


#@onready var item_progress_bars: Dictionary = {
	#Globals.ItemLocation.LEFT: NodePath("Control/Inventory/EquippedItems/LeftItemSlot/LeftAmmoIndicator"),
	#Globals.ItemLocation.RIGHT: NodePath("Control/Inventory/EquippedItems/RightItemSlot/RightAmmoIndicator"),
	#Globals.ItemLocation.BACK: NodePath("Control/Panel/AmmoIndicators/BackAmmoIndicator"),
#}
#
#@onready var item_slots: Dictionary = {
	#Globals.ItemLocation.LEFT:  NodePath("Control/Inventory/EquippedItems/LeftItemSlot"),
	#Globals.ItemLocation.RIGHT: NodePath("Control/Inventory/EquippedItems/RightItemSlot"),
	#Globals.ItemLocation.BACK:  NodePath("Control/ItemSlots/BackItemSlot"),
#}

var glow_materials = {
	"blue" : preload("res://Materials/blue_laser_mat.tres"), 
	"pink" : preload("res://Materials/pink_laser_mat.tres"),
	"red" : preload("res://Materials/red_laser_mat.tres"),
}
