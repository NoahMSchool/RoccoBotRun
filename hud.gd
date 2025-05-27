extends CanvasLayer

@onready var label_node = $Control/Panel/Label
@onready var left_ammo_indicator: ProgressBar = $Control/Panel/LeftAmmoIndicator

@onready var item_progress_bars: Dictionary = {
	Globals.ItemLocation.LEFT: NodePath("Control/Panel/AmmoIndicators/LeftAmmoIndicator"),
	Globals.ItemLocation.RIGHT: NodePath("Control/Panel/AmmoIndicators/RightAmmoIndicator"),
	Globals.ItemLocation.BACK: NodePath("Control/Panel/AmmoIndicators/BackAmmoIndicator"),
}


func change_label(text : String):
	label_node.text = text

func change_ammo_progress(item_location : Globals.ItemLocation, value : float):
	var progress_bar_node = get_node_or_null(item_progress_bars[item_location])
	if progress_bar_node:
		progress_bar_node.value = value
