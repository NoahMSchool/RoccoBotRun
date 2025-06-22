extends CanvasLayer

#@onready var label_node = $Control/Panel/Label



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
	
@onready var rocco_bot_node: CharacterBody3D = $"../RoccoBot"

func change_label(text : String):
	#label_node.text = text
	pass
	
func change_charge_progress(item_location : PlayerItemLocation, value : float):
	var progress_bar_node = get_node_or_null(item_location.item_progress_bar_path)
	if progress_bar_node:
		progress_bar_node.value = value


func update_inventory(equipped_items : Array, inventory_items : Array):
	update_equipped_items(equipped_items)
	update_inventory_items(inventory_items)
	
func update_equipped_items(items_array : Array):
	for item in items_array:
		var item_node = rocco_bot_node.get_node_or_null(item.node_path).get_child(0)
		var item_slot_control_node = get_node_or_null(item.inventory_slot_path)
		if item_slot_control_node:
			var texture_node = item_slot_control_node.get_child(0) as TextureRect
			texture_node.texture = item_node.icon
			if item_node.has_node("ChargeComponent"):
				var progress_bar_node = item_slot_control_node.get_child(1)
				if progress_bar_node:
					var charge_component_node = item_node.get_node("ChargeComponent")
					progress_bar_node.value = charge_component_node.get_charge_percent()
					##should hud call this
		
func update_inventory_items(items_array : Array):
	for i in len(inventory_slots):
		var item_slot_control_node = get_node_or_null(inventory_slots[i])
		if item_slot_control_node:
			var texture_node = item_slot_control_node.get_child(0) as TextureRect
			if len(items_array) > i:
				var item = items_array[i] as Item
				texture_node.texture = item.icon
			else:
				texture_node.texture = null
			

func clear_item(item_location : PlayerItemLocation):
	var item_slot_node = get_node_or_null(item_location.inventory_slot_path)
	if item_slot_node:
		var texture_node = item_slot_node.get_child(0) as TextureRect
		texture_node.texture = null
	
