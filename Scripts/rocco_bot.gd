extends CharacterBody3D

#@onready var item_slot_nodes: Dictionary = {
	#Globals.ItemLocation.LEFT: NodePath("Object/Items/EquippedItems/LeftHandItem"),
	#Globals.ItemLocation.RIGHT: NodePath("Object/Items/EquippedItems/RightHandItem"),
	#Globals.ItemLocation.BACK: NodePath("Object/Items/EquippedItems/BackItem"),
#}
#
#@onready var item_actions: Dictionary = {
	#Globals.ItemLocation.LEFT: ["left_action", false, "swap_left_action"],
	#Globals.ItemLocation.RIGHT: ["right_action", false, "swap_right_action"],
	#Globals.ItemLocation.BACK: ["none", false, "swap_back_action"]
#}

#Components
@export var health_component : HealthComponent = null
@export var damagable_component : DamagableComponent = null


#Movement Exports
@export var SPEED = 4.0
@export var jump_height = 4.5
@export var super_jump_height = 9
@export var super_jump_time = 0.5
@export var cam_sens = 0.00025

var jump_time = 0.0
var current_speed = SPEED
var mouse_delta = Vector2.ZERO

#HUD
@onready var hud: CanvasLayer = $"../HUD"
@export var spawnpoint : Node3D

var Left

func use_item(item_location : PlayerItemLocation):
	var item = get_equiped_item(item_location)
	item.use_item(item_location.used_last)

func add_item(packed_scene : PackedScene):
	var configured_item = Item.create_item(packed_scene)
	configured_item.set_enabled(false)
	$Object/Items/InventoryItems.add_child(configured_item)
	auto_equip_items()

func get_equiped_item(item_location : PlayerItemLocation):
	var slot_node = get_node_or_null(item_location.node_path)
	if slot_node:
		return slot_node.get_child(0)

func auto_equip_items():
	var first_inventory_item = $Object/Items/InventoryItems.get_child(0)
	if first_inventory_item:
		for item_location in Globals.player_item_locations:
			var slot_node = get_node_or_null(item_location.node_path)
			if slot_node and slot_node.get_child(0) == null:
				equip_item(first_inventory_item, item_location)
				break

func equip_item(item : Item, item_location : PlayerItemLocation):
	var slot_node = get_node_or_null(item_location.node_path)
	if slot_node:
		unequip_item(item_location)
		item.reparent(slot_node, false)
		item.set_enabled(true)
		$Sounds/EquipWeapon.play()
		

func unequip_item(item_location : PlayerItemLocation):
	var item = get_equiped_item(item_location)
	if item:
		item.reparent($Object/Items/InventoryItems, false)
		item.set_enabled(false)

func update_HUD():
	var inventory_items : Array = get_inventory_items()
	var equipped_items : Array = []
	
	for item_location in Globals.player_item_locations:
		var slot_node = get_node_or_null(item_location.node_path)
		if slot_node and slot_node.get_child_count()>0:
			var item = slot_node.get_child(0)
			equipped_items.append(item_location)
			
	hud.update_inventory(equipped_items, inventory_items)
	

func get_inventory_items() -> Array:
	return $Object/Items/InventoryItems.get_children()

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$CamPivot/Camera3D.current = true
	$Camera3DFollow.current = false
	GameManager.connect("reset_level", Callable(self, "respawn"))
	
func _physics_process(delta: float) -> void:
	current_speed = SPEED
	#preventing looking behind objects
	$CamPivot/Camera3D.position = lerp($CamPivot/Camera3D.position, $CamPivot/SpringArm3D/CamPos.position, 15*delta)
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	#jumping
	if Input.is_action_just_released("jump") and is_on_floor():
		if jump_time > super_jump_time:
			velocity.y = super_jump_height
		else:
			velocity.y = jump_height

	#if Input.is_action_pressed("shift"):
		#var item_location : Globals.ItemLocation
		#if Input.is_action_just_pressed("left_action"):
			#item_location = Globals.ItemLocation.LEFT
		#elif Input.is_action_just_pressed("right_action"):
			#item_location = Globals.ItemLocation.RIGHT
		#var first_inventory_item = $Object/Items/InventoryItems.get_child(0)
		#
		#if first_inventory_item and item_location:
			##print("equiping ", first_inventory_item, item_location)
			#equip_item(first_inventory_item, item_location)
	#
	#elif Input.is_action_pressed("control"):
		#var item_location : Globals.ItemLocation
		#if Input.is_action_just_pressed("left_action"):
			#item_location = Globals.ItemLocation.LEFT
		#elif Input.is_action_just_pressed("right_action"):
			#item_location = Globals.ItemLocation.RIGHT
		#if item_location and get_equiped_item(item_location):
			#unequip_item(item_location)
		#
	#else:
	for item_location in Globals.player_item_locations:
		if Input.is_action_pressed(item_location.use_action) and get_node(item_location.node_path).get_child_count()>0:
			if item_location.used_last == false:
				use_item(item_location)
			else:
				use_item(item_location)
			item_location.used_last = true
		else:
			item_location.used_last = false
				
	if Input.is_action_pressed("jump") and is_on_floor():
		jump_time += delta
		current_speed /= 2
		
	else:
		jump_time = 0
	
	
	#get movement direction
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	#input_dir = Input.get_vector(Input.get_action_strength("left_joystick_right"), Input.get_action_strength("left_joystick_left"), Input.get_action_strength("left_joystick_up"), Input.get_action_strength("left_joystick_down"))
	
	#input_dir.x = Input.get_action_strength("left_joystick_right") - Input.get_action_strength("left_joystick_left")
	#input_dir.y = Input.get_action_strength("left_joystick_up") - Input.get_action_strength("left_joystick_down")
	
	var direction = ($CamPivot.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if input_dir != Vector2.ZERO:
		pass
		$Object.rotation_degrees.y = $CamPivot.rotation_degrees.y - rad_to_deg(input_dir.angle())-90

	#move velocity to direction or to zero
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)
	
	
	
	$SpringArm3D.global_position = lerp($SpringArm3D.global_position, global_position, 5*delta)
	$Camera3DFollow.global_position = lerp($Camera3DFollow.global_position, $SpringArm3D/CamPos.global_position, 7.5*delta)

	
	move_and_slide()
	
	update_HUD()
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		$CamPivot.rotation.y -= event.relative.x*cam_sens
		$CamPivot.rotation.x -= event.relative.y*cam_sens
		$CamPivot.rotation.x = clamp($CamPivot.rotation.x, -PI/4, PI/8)

func die():
	pass

func respawn():
	global_transform = spawnpoint.get_node("SpawnPos").global_transform

func foreground_item(foreground : bool, item_location : PlayerItemLocation):
	if foreground:
		get_node(item_location.node_path).position = item_location.foreground_position
	else:
		get_node(item_location.node_path).position = item_location.restw_position

#TODO
"""
Make Player allign with ground

Add ability to push objects
"""
