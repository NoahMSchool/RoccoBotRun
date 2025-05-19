
extends CharacterBody3D


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

#:
	#get:
		#if items[0]:
			#equip_item(items[0], -1)
		#if items[1]:
			#equip_item(items[1], 1)
		#
		#return items
	#set(value):
		#items = value

@onready var right_item = null
@onready var left_item = null

func configure_item(item : Item):
	if item is Weapon:
		item.accent_color = "blue"
		#item.target_group = "enemies"

func add_item(item : Item):
	var configured_item = configure_item(item)
	items.append(configured_item)
	equip_item(configured_item, right_item)

func equip_item(item_scene : PackedScene, hand : bool):
	var item = item_scene.instantiate()
	if hand:
		left_item = item
		$Object/Items/LeftHandItem.add_child(item)
	else:
		$Object/Items/RightHandItem.add_child(item)
		right_item = item
	

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
	
	if Input.is_action_pressed("right_action"):
		if right_item:
			right_item.fire()			
	
	if Input.is_action_pressed("left_action"):
		if left_item:
			left_item.fire()
		
	if Input.is_action_just_pressed("test"):
		var laser_scene = preload("res://Scenes/WeaponScenes/laser_cannon.tscn")
		var launcher_scene = preload("res://Scenes/WeaponScenes/grenade_launcher.tscn")
		equip_item(launcher_scene, false)
		equip_item(laser_scene, true)
		
		
		
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
