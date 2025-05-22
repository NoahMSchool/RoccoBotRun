
extends CharacterBody3D

#Should I do a dictionary of itemlocation to node path
enum ItemLocation {
	LEFT, 
	RIGHT,
}

@export var SPEED = 4.0
@export var jump_height = 4.5
@export var super_jump_height = 9

@export var super_jump_time = 0.5
var jump_time = 0.0

var current_speed = SPEED

@export var spawnpoint : Node3D

var mouse_delta = Vector2.ZERO

@export var cam_sens = 0.00025

@onready var items : Array[Item] = []

var laser_scene = preload("res://Scenes/WeaponScenes/laser_cannon.tscn")
var launcher_scene = preload("res://Scenes/WeaponScenes/grenade_launcher.tscn")

func fire_item(item_location : ItemLocation):
	var item = get_equiped_item(item_location)
	if item:
		item.fire()

func add_item(packed_scene : PackedScene):
	var configured_item = Item.create_item(packed_scene)
	configured_item.set_enabled(false)
	items.append(configured_item)
	$Object/Items/InventoryItems.add_child(configured_item)
	update_items()
#Make disable/enable node to avoid repeated code

func get_equiped_item(item_location : ItemLocation):
	if item_location == ItemLocation.LEFT:
		return $Object/Items/LeftHandItem.get_child(0)
	else:
		return $Object/Items/RightHandItem.get_child(0)

func update_items():
	if items.size() > 0:
		if $Object/Items/LeftHandItem.get_child_count() > 0:
			unequip_item(ItemLocation.LEFT)
		equip_item(items[0], ItemLocation.LEFT)
	
	if items.size() > 1:
		if $Object/Items/RightHandItem.get_child_count() > 0:
			unequip_item(ItemLocation.RIGHT)
		equip_item(items[1], ItemLocation.RIGHT)

func equip_item(item : Item, item_location : ItemLocation):
	if item_location == ItemLocation.LEFT:
		item.reparent($Object/Items/LeftHandItem, false)
		item.set_enabled(true)
	elif item_location == ItemLocation.RIGHT:
		item.reparent($Object/Items/RightHandItem, false)
		item.set_enabled(true)

func unequip_item(item_location : ItemLocation):
	var item = get_equiped_item(item_location)
	if item:
		item.reparent($Object/Items/InventoryItems, item_location)
		item.set_enabled(false)
	
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$CamPivot/Camera3D.current = true
	$Camera3DFollow.current = false
	
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

			
	if Input.is_action_pressed("jump") and is_on_floor():
		jump_time += delta
		current_speed /= 2
		
	else:
		jump_time = 0
	
	if Input.is_action_pressed("left_action"):
		fire_item(ItemLocation.LEFT)
	if Input.is_action_pressed("right_action"):
		fire_item(ItemLocation.RIGHT)		
	
	if Input.is_action_just_pressed("test"):
		update_items()
	
	if Input.is_action_just_pressed("test2"):
		add_item(laser_scene)
	
	if Input.is_action_just_pressed("test3"):
		pass
		
		
		
	#get movement direction
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
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
		
	#quiting
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	
	$SpringArm3D.global_position = lerp($SpringArm3D.global_position, global_position, 5*delta)
	$Camera3DFollow.global_position = lerp($Camera3DFollow.global_position, $SpringArm3D/CamPos.global_position, 7.5*delta)

	
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	#Rotating Cam Pivot based on mouse0
	#return
	if event is InputEventMouseMotion:
		$CamPivot.rotation.y -= event.relative.x*cam_sens
		$CamPivot.rotation.x -= event.relative.y*cam_sens
		$CamPivot.rotation.x = clamp($CamPivot.rotation.x, -PI/4, PI/8)
	
func die():
	pass

func respawn():
	global_transform = spawnpoint.get_node("SpawnPos").global_transform

#TODO
"""
Make Player allign with ground

Add ability to push objects
"""
