extends CharacterBody3D

@onready var skeleton : Skeleton3D = $Object/Skeleton3D
@onready var anim_player = $AnimationPlayer
@onready var anim_blend_tree = $AnimationTree

@onready var right_aim_ik: SkeletonIK3D = $Object/Skeleton3D/RightAimIK
@onready var left_aim_ik: SkeletonIK3D = $Object/Skeleton3D/LeftAimIK


enum AnimState {IDLE, WALK, CROUCH_WALK, CROUCH, ASC, DESC, FALLING}
var current_anim : AnimState = AnimState.IDLE
var blend_speed = 5

var idle_val : float = 0
var walk_val : float = 0
var falling_val : float = 0
var descend_val : float = 0
var ascend_val : float = 0
var crouch_val : float = 0

#Components
@export var health_component : HealthComponent = null
@export var damagable_component : DamagableComponent = null

#Movement Exports
@export var speed = 4
@export var ground_grip = 48
@export var air_control = 12
@export var jump_height = 4
@export var super_jump_height = 8
@export var super_jump_time = 0.5
@export var cam_sens = 0.00025

var jump_time = 0.0
var current_speed = speed
var mouse_delta = Vector2.ZERO

#sounds
#var jump_sound = preload("res://RoccoBot/Sounds/Sound Jump by Odeean.wav")
var jump_sound = preload("res://RoccoBot/Sounds/Jump 01 by Michael Kur95.wav")
var super_jump_on_sound = preload("res://RoccoBot/Sounds/Sound Jump by Odeean.wav")

#HUD
@onready var hud: CanvasLayer = $"../HUD"

@export var spawnpoint : Node3D

func update_animations(delta):
	match current_anim:
		AnimState.IDLE:
			#anim_blend_tree.set("parameters/Movement/transition_request", "Idle")
			idle_val = move_toward(idle_val, 1, blend_speed*delta)
			
			walk_val = move_toward(walk_val, 0, blend_speed*delta)
			falling_val = move_toward(falling_val, 0, blend_speed*delta)
			descend_val = move_toward(descend_val, 0, blend_speed*delta)
			ascend_val = move_toward(ascend_val, 0, blend_speed*delta)
			crouch_val = move_toward(crouch_val, 0, blend_speed*delta)

		AnimState.WALK:
			walk_val = move_toward(walk_val, 1, blend_speed*delta)
			
			idle_val = move_toward(idle_val, 0, blend_speed*delta)
			falling_val = move_toward(falling_val, 0, blend_speed*delta)
			descend_val = move_toward(descend_val, 0, blend_speed*delta)
			ascend_val = move_toward(ascend_val, 0, blend_speed*delta)
			crouch_val = move_toward(crouch_val, 0, blend_speed*delta)

		AnimState.CROUCH_WALK:
			walk_val = move_toward(walk_val, 0.5, blend_speed*delta)
			crouch_val = move_toward(crouch_val, 0.5, blend_speed*delta)
			
			idle_val = move_toward(idle_val, 0, blend_speed*delta)
			falling_val = move_toward(falling_val, 0, blend_speed*delta)
			descend_val = move_toward(descend_val, 0, blend_speed*delta)
			ascend_val = move_toward(ascend_val, 0, blend_speed*delta)
		
		AnimState.CROUCH:
			crouch_val = move_toward(crouch_val, 0.5, blend_speed*delta)
			idle_val = move_toward(idle_val, 0.5, blend_speed*delta)
			
			walk_val = move_toward(walk_val, 0, blend_speed*delta)
			ascend_val = move_toward(ascend_val, 0, blend_speed*delta)
			falling_val = move_toward(falling_val, 0, blend_speed*delta)
			descend_val = move_toward(descend_val, 0, blend_speed*delta)
		
		AnimState.ASC:
			ascend_val = move_toward(ascend_val, 1, blend_speed*delta)
			
			walk_val = move_toward(walk_val, 0, blend_speed*delta)
			crouch_val = move_toward(crouch_val, 0, blend_speed*delta)
			idle_val = move_toward(idle_val, 0, blend_speed*delta)
			falling_val = move_toward(falling_val, 0, blend_speed*delta)
			descend_val = move_toward(descend_val, 0, blend_speed*delta)
			
		AnimState.DESC:
			descend_val = move_toward(descend_val, 1, blend_speed*delta)
			
			walk_val = move_toward(walk_val, 0, blend_speed*delta)
			crouch_val = move_toward(crouch_val, 0, blend_speed*delta)
			idle_val = move_toward(idle_val, 0, blend_speed*delta)
			falling_val = move_toward(falling_val, 0, blend_speed*delta)
			ascend_val = move_toward(ascend_val, 0, blend_speed*delta)
			
		AnimState.FALLING:
			falling_val = move_toward(falling_val, 1, blend_speed*delta)
			
			idle_val = move_toward(idle_val, 0, blend_speed*delta)
			walk_val = move_toward(walk_val, 0, blend_speed*delta)
			descend_val = move_toward(descend_val, 0, blend_speed*delta)
			ascend_val = move_toward(ascend_val, 0, blend_speed*delta)
			crouch_val = move_toward(crouch_val, 0, blend_speed*delta)
	
	anim_blend_tree["parameters/idle/blend_amount"] = idle_val
	anim_blend_tree["parameters/walk/blend_amount"] = walk_val
	anim_blend_tree["parameters/falling/blend_amount"] = falling_val
	anim_blend_tree["parameters/crouch/blend_amount"] = crouch_val
	anim_blend_tree["parameters/ascend/blend_amount"] = ascend_val
	anim_blend_tree["parameters/descend/blend_amount"] = descend_val


func use_item_at_location(item_location : PlayerItemLocation, is_release):
	var item = get_equiped_item(item_location)
	var ik = get_node_or_null(item_location.targeting_IK_path)
	if is_release:
		item.release_item()
		ik.stop()
		#right_aim_ik.influence = 0
		#left_aim_ik.influence = 0
	else:
		#left_aim_ik.influence = 1
		#right_aim_ik.influence = 1

		ik.start()
		item.use_item()

	
	

func add_item(packed_scene : PackedScene):
	var configured_item = Item.create_item(packed_scene)
	configured_item.set_enabled(false)
	$Object/Items/InventoryItems.add_child(configured_item)
	auto_equip_items()

func remove_item(item_location : PlayerItemLocation):
	var item = get_node(item_location.node_path)
	item.queue_free()
	#remove this properly
	
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
	item_location.used_last = true
	
	if slot_node:
		$Sounds/EquipWeapon.play()
		unequip_item(item_location)
		item.reparent(slot_node, false)
		item.set_enabled(true)
		#if item.has_signal():
		var cb = Callable(self, "foreground_item").bind(item_location)
		item.connect("item_foregrounded", cb)
		item.connect("item_used", Callable())
		item.item_used.connect(unequip_item.bind(item_location))

func unequip_item(item_location : PlayerItemLocation):
	var item = get_equiped_item(item_location)
	if item:
		item.reparent($Object/Items/InventoryItems, false)
		var cb = Callable(self, "foreground_item").bind(item_location)
		item.disconnect("item_foregrounded", cb)

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
	
	var anim_player : AnimationPlayer = $AnimationPlayer
	var old_root = "RoccobotRig/Skeleton3D"
	var new_root = "Object/RoccobotRig/Skeleton3D"
		
	if !anim_player:
		print("no anim player found")
		return
	else:
		print("hi")
		print(anim_player.current_animation)


func _physics_process(delta: float) -> void:
	#print(anim_player.current_animation)
	current_speed = speed
	#get movement direction
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction = ($CamPivot.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if input_dir != Vector2.ZERO:
		$Object.rotation_degrees.y = $CamPivot.rotation_degrees.y - rad_to_deg(input_dir.angle())-90
	
	#air logic
	if not is_on_floor():
		velocity += get_gravity() * delta
		if velocity.y > 0:
			#anim_player.play("ascend")
			current_anim = AnimState.ASC
		else:
			if velocity.y<-jump_height:
				#anim_player.play("falling")
				current_anim = AnimState.FALLING
			else:
				#anim_player.play("descend")
				current_anim = AnimState.DESC

		if direction.x:
			velocity.x = move_toward(velocity.x, current_speed*direction.x, air_control*delta)
		else:
			velocity.x = move_toward(velocity.x, 0, air_control/2*delta)		
		if direction.z:
			velocity.z = move_toward(velocity.z, current_speed*direction.z, air_control*delta)
		else:
			velocity.z = move_toward(velocity.z, 0, air_control/2*delta)
	#ground logic
	else:
		
		#Put this in same if statement
		if Input.is_action_pressed("jump"):
			pass
			current_speed *= 0.75

		if direction.x:
			velocity.x = move_toward(velocity.x, current_speed*direction.x, ground_grip*delta)
		else:
			velocity.x = move_toward(velocity.x, 0, ground_grip*delta)		
		if direction.z:
			velocity.z = move_toward(velocity.z, current_speed*direction.z, ground_grip*delta)
		else:
			velocity.z = move_toward(velocity.z, 0, ground_grip*delta)
			
		if direction:
			#anim_player.play("walk")
			current_anim = AnimState.WALK
		else:
			#anim_player.play("idle")
			current_anim = AnimState.IDLE
		
		#jumping
		if Input.is_action_just_released("jump"):
			$Sounds/JumpSound.stream = jump_sound
			$Sounds/JumpSound.play()
			if jump_time >= super_jump_time:
				velocity.y = super_jump_height
			else:
				velocity.y = jump_height
		
		if Input.is_action_pressed("jump"):
			if(direction.x or direction.y):#Do I need both 
				current_anim = AnimState.CROUCH_WALK
			else:
				current_anim = AnimState.CROUCH
			#anim_player.play("crouch")
			
			if jump_time<super_jump_time:
				jump_time += delta
				if jump_time >= super_jump_time:
					$Sounds/JumpSound.stream = super_jump_on_sound
					$Sounds/JumpSound.play()
		else:
			jump_time = 0
		
	#camera
	#preventing looking behind objects
	$CamPivot/Camera3D.position = lerp($CamPivot/Camera3D.position, $CamPivot/SpringArm3D/CamPos.position, 15*delta)
	
	
	$SpringArm3D.global_position = lerp($SpringArm3D.global_position, global_position, 5*delta)
	$Camera3DFollow.global_position = lerp($Camera3DFollow.global_position, $SpringArm3D/CamPos.global_position, 7.5*delta)
	update_animations(delta)
	move_and_slide()
	
	#using items
	for item_location in Globals.player_item_locations:
		if Input.is_action_just_pressed(item_location.swap_action):
			var first_inventory_item = $Object/Items/InventoryItems.get_child(0)
			
			if first_inventory_item:
				equip_item(first_inventory_item, item_location)
			
		elif Input.is_action_pressed(item_location.use_action) and get_node(item_location.node_path).get_child_count()>0:
			use_item_at_location(item_location, false)
		elif Input.is_action_just_released(item_location.use_action) and get_node(item_location.node_path).get_child_count()>0:
			use_item_at_location(item_location, true)
	update_HUD()

func _process(delta: float) -> void:
	#controller look doesnt work
	var lx = Input.get_action_strength("right_joystick_right") - Input.get_action_strength("right_joystick_left")
	var ly = Input.get_action_strength("right_joystick_down") - Input.get_action_strength("right_joystick_up")
	
	$CamPivot.rotation.y += -lx * cam_sens*10000*delta
	$CamPivot.rotation.x += -ly * cam_sens*10000*delta
	$CamPivot.rotation.x = clamp($CamPivot.rotation.x, -PI/4, PI/8)

func _unhandled_input(event: InputEvent) -> void:
	
	if event is InputEventMouseMotion:
		$CamPivot.rotation.y -= event.relative.x*cam_sens
		$CamPivot.rotation.x -= event.relative.y*cam_sens
		$CamPivot.rotation.x = clamp($CamPivot.rotation.x, -PI/4, PI/8)
	
	
	#$CamPivot.rotate_y(-lx * cam_sens*100)
	#$CamPivot.rotate_x(-ly * cam_sens*100)

	
func die():
	pass

func respawn():
	global_transform = spawnpoint.get_node("SpawnPos").global_transform

#TODO
"""
Make Player allign with ground

Add ability to push objects
"""
