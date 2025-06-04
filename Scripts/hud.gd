extends CanvasLayer

#@onready var label_node = $Control/Panel/Label



@onready var item_progress_bars: Dictionary = {
	Globals.ItemLocation.LEFT: NodePath("Control/Inventory/EquippedItems/LeftItemSlot/LeftAmmoIndicator"),
	Globals.ItemLocation.RIGHT: NodePath("Control/Inventory/EquippedItems/LeftItemSlot/RightAmmoIndicator"),
	Globals.ItemLocation.BACK: NodePath("Control/Panel/AmmoIndicators/BackAmmoIndicator"),
}

@onready var item_slots: Dictionary = {
	Globals.ItemLocation.LEFT:  NodePath("Control/Inventory/EquippedItems/LeftItemSlot"),
	Globals.ItemLocation.RIGHT: NodePath("Control/Inventory/EquippedItems/RightItemSlot"),
	Globals.ItemLocation.BACK:  NodePath("Control/ItemSlots/BackItemSlot"),
}

@onready var inventory_slots : Array = [
	NodePath("Control/Inventory/InventoryItems/ItemSlot"),
	NodePath("Control/Inventory/InventoryItems/ItemSlot2"),
	NodePath("Control/Inventory/InventoryItems/ItemSlot3"),
	NodePath("Control/Inventory/InventoryItems/ItemSlot4"),
	NodePath("Control/Inventory/InventoryItems/ItemSlot5"),
	NodePath("Control/Inventory/InventoryItems/ItemSlot6"),
	NodePath("Control/Inventory/InventoryItems/ItemSlot7"),
	NodePath("Control/Inventory/InventoryItems/ItemSlot8")
	
	]

func change_label(text : String):
	#label_node.text = text
	pass
	
func change_ammo_progress(item_location : Globals.ItemLocation, value : float):
	var progress_bar_node = get_node_or_null(item_progress_bars[item_location])
	if progress_bar_node:
		progress_bar_node.value = value

func update_inventory_items(items_array : Array):
	for i in len(inventory_slots):
		var item_slot_node = get_node_or_null(inventory_slots[i])
		if item_slot_node:
			var texture_node = item_slot_node.get_child(0) as TextureRect
			if len(items_array) > i:
				var item = items_array[i] as Item
				texture_node.texture = item.icon
			else:
				texture_node.texture = null
				
func update_item(item : Item, item_location : Globals.ItemLocation):
	var item_slot_node = get_node_or_null(item_slots[item_location])
	if item_slot_node:
		var texture_node = item_slot_node.get_child(0) as TextureRect
		texture_node.texture = item.icon


func clear_item(item_location : Globals.ItemLocation):
	var item_slot_node = get_node_or_null(item_slots[item_location])
	if item_slot_node:
		var texture_node = item_slot_node.get_child(0) as TextureRect
		texture_node.texture = null
	
