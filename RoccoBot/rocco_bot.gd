extends CharacterBody3D

signal died

@onready var skeleton : Skeleton3D = $Character/RoccoBotRig/Skeleton3D
@onready var anim_player = $Character/AnimationPlayer
@onready var anim_blend_tree = $Character/AnimationTree

#@onready var right_aim_ik: SkeletonIK3D = $Object/Skeleton3D/RightAimIK
#@onready var left_aim_ik: SkeletonIK3D = $Object/Skeleton3D/LeftAimIK

var item_locations = [
	PlayerItemLocation.new("Character/RoccoBotRig/Skeleton3D/LeftItemAttatch/LeftItemLocation", "left_action", "swap_left_action", "Control/Inventory/EquippedItems/LeftItemSlot", "Control/Inventory/EquippedItems/LeftItemSlot/LeftAmmoIndicator", "Character/RoccoBotRig/Skeleton3D/LeftAimIK", "left_lock"),
	PlayerItemLocation.new("Character/RoccoBotRig/Skeleton3D/RightItemAttatch/RightItemLocation", "right_action", "swap_right_action","Control/Inventory/EquippedItems/RightItemSlot", "Control/Inventory/EquippedItems/RightItemSlot/LeftAmmoIndicator", "Character/RoccoBotRig/Skeleton3D/RightAimIK", "right_lock"), 
	]

enum Modifiers {
	ICEFEET
}

var active_effects : Array[Modifiers] = []
var interactable_items : Array[Node3D]


#animation
enum AnimState {IDLE, WALK, CROUCH_WALK, CROUCH, ASC, DESC, FALLING}
var current_anim : AnimState = AnimState.IDLE
var blend_speed = 5

var idle_val : float = 0
var walk_val : float = 0
var falling_val : float = 0
var descend_val : float = 0
var ascend_val : float = 0
var crouch_val : float = 0

#camera rotation
const rotation_time = 0.25
const rotation_increment : float = PI/4
var target_facing_direction : float = 0
var facing_direction : float = 0
var time_last_rotated : float = 0
var last_set_rotation : float = facing_direction

var target_pos : Vector3

#Components
@export var health_component : HealthComponent = null
@export var damagable_component : DamagableComponent = null

#Movement Exports
@export var speed_default = 4
@export var ground_grip_default = 48
@export var air_control_default = 12
@export var jump_height_default = 4
@export var super_jump_height_default = 8
@export var super_jump_time = 0.5
@export var cam_sens = 0.00025
#GoTo Line 250 to swich camera being used
@onready var current_cam = $Camera3DFollow
@export var camangle : float = 0
@export var topdown_angle : float = 045
@export var topdown_distance : float = 7.5

@export var item_pullout : = 15

var speed = speed_default
var ground_grip = ground_grip_default
var air_control = air_control_default
var jump_height = jump_height_default
var super_jump_height = super_jump_height_default


@onready var team_string = "player"
@onready var team :Team

var jump_time = 0.0
var current_speed = speed
var mouse_delta = Vector2.ZERO

#sounds
#var jump_sound = preload("res://RoccoBot/Sounds/Sound Jump by Odeean.wav")
var jump_sound = preload("res://RoccoBot/Sounds/Jump 01 by Michael Kur95.wav")
var super_jump_on_sound = preload("res://RoccoBot/Sounds/Sound Jump by Odeean.wav")


#HUD
@onready var hud: CanvasLayer = $"../HUD"

func add_interactable(item):
	self.interactable_items.append(item)
func remove_interactable(item):
	self.interactable_items.erase(item)

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

func add_effect(effect : Modifiers):
	active_effects.append(effect)
	update_effects()
func remove_effect(effect : Modifiers):
	active_effects.erase(effect)
	update_effects()
	

func update_effects():
	for effect in active_effects:
		if effect == Modifiers.ICEFEET:
			ground_grip = 2
			air_control = 4
			speed = speed_default + 4/3
		else:
			ground_grip = ground_grip_default
			air_control = air_control_default
			speed = speed_default


func use_item_at_location(item_location : PlayerItemLocation, is_release):
	var item = get_equiped_item(item_location)
	var ik : SkeletonModifier3D = get_node_or_null(item_location.targeting_IK_path)
	if ik.influence == 1.0:
		if is_release:
			item.release_item()
			#ik.influence = 0.0	
		else:
			#ik.influence = 1.0
			item.use_item()

func add_item(packed_scene : PackedScene):
	var configured_item = Item.create_item(packed_scene, team.accent_color)
	#print(team, team.accent_color, team.group)
	configured_item.set_enabled(false)
	$Character/InventoryItems.add_child(configured_item)
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
	var first_inventory_item = $Character/InventoryItems.get_child(0)
	if first_inventory_item:
		for item_location in item_locations:
			var slot_node = get_node_or_null(item_location.node_path)
			if slot_node and slot_node.get_child(0) == null:
				equip_item(first_inventory_item, item_location)
				break

func equip_item(item : Item, item_location : PlayerItemLocation):
	var slot_node = get_node_or_null(item_location.node_path)

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
		item.reparent($Character/InventoryItems, false)
		var cb = Callable(self, "foreground_item").bind(item_location)
		item.disconnect("item_foregrounded", cb)

		item.set_enabled(false)

func update_HUD():
	var inventory_items : Array = get_inventory_items()
	var equipped_items : Array = []
	
	for item_location in item_locations:
		var slot_node = get_node_or_null(item_location.node_path)
		if slot_node and slot_node.get_child_count()>0:
			var item = slot_node.get_child(0)
			equipped_items.append(item_location)
			
	hud.update_inventory(equipped_items, inventory_items)
	

func get_inventory_items() -> Array:
	return $Character/InventoryItems.get_children()

func get_raymousepos():
	var mouse_pos : Vector2 = get_viewport().get_mouse_position()
	var ray_length = 1000
	var from = current_cam.project_ray_origin(mouse_pos)
	var to = from + current_cam.project_ray_normal(mouse_pos)*ray_length
	var space = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.from = from
	ray_query.to = to
	var raycast_result = space.intersect_ray(ray_query)
	if raycast_result:
		return raycast_result["position"]
	else:
		return null

func _ready() -> void:
	team = Globals.get_team(team_string)	
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	#$CamPivot/Camera3D.current = false
	current_cam.current = true
	$SpringArm3D.rotation.x = -deg_to_rad(topdown_angle)
	current_cam.rotation.x = -deg_to_rad(topdown_angle)
	$SpringArm3D.spring_length = topdown_distance

func _physics_process(delta: float) -> void:
	#print(anim_player.current_animation)
	current_speed = speed
	#get movement direction
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	
	var direction = ($SpringArm3D.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if input_dir != Vector2.ZERO:
		rotation.y = atan2(direction.x, direction.z)+PI
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
		

	#$SpringArm3D.global_position = lerp($SpringArm3D.global_position, global_position, 5*delta)
	$SpringArm3D.global_position = global_position

	current_cam.global_position = lerp(current_cam.global_position, $SpringArm3D/CamPos.global_position, 7.5*delta)
	update_animations(delta)
	move_and_slide()
	
	if Input.is_action_just_pressed("select_primary"):
		get_raymousepos()
	#using items
	
	for item_location in item_locations:
		var item_location_ik : SkeletonModifier3D = get_node_or_null(item_location.targeting_IK_path)
		if Input.is_action_just_pressed(item_location.swap_action):
			var first_inventory_item = $Character/InventoryItems.get_child(0)
			
			if first_inventory_item:
				equip_item(first_inventory_item, item_location)
			
		elif Input.is_action_pressed(item_location.use_action) and get_node(item_location.node_path).get_child_count()>0:
			use_item_at_location(item_location, false)
			#var rightbone: bone = $Character/RoccoBotRig/Skeleton3D.find_bone("hand.R")
			#$Character/RoccoBotRig/Skeleton3D.set_bone_pose_rotation(rightbone, lerpf())
			item_location_ik.influence = move_toward(item_location_ik.influence, 1.0, delta*item_pullout)
		elif Input.is_action_just_released(item_location.use_action) and get_node(item_location.node_path).get_child_count()>0:
			use_item_at_location(item_location, true)
		else:
			item_location_ik.influence = move_toward(item_location_ik.influence, 0.0, delta*item_pullout/2)
		
		anim_blend_tree["parameters/"+item_location.anim_filter_name+"/blend_amount"] = item_location_ik.influence
			#get_node_or_null(item_location.targeting_IK_path).influence = move_toward(get_node_or_null(item_location.targeting_IK_path).influence, 0.0, 0.1)
	#$Character/RightIKPivot.look_at(target_pos)
	
	#var dir_to_target = (target_pos-global_position).normalized()
	#dir_to_target.y = 0
	#rotation.y = atan2(dir_to_target.x, dir_to_target.z)+PI
	update_HUD()
	
func _process(delta: float) -> void:
	time_last_rotated += delta
	time_last_rotated = min(time_last_rotated, rotation_time)
	if Input.is_action_just_pressed("interact"):
		for i in interactable_items:
			i.interact()
			print(i)
	if Input.is_action_just_pressed("rightarrow"):
		target_facing_direction -=rotation_increment
		time_last_rotated = 0
		last_set_rotation = facing_direction
		#target_facing_direction = snappedf(target_facing_direction, PI/2)
	if Input.is_action_just_pressed("leftarrow"):
		target_facing_direction+=rotation_increment
		time_last_rotated = 0
		last_set_rotation = facing_direction
		#target_facing_direction = snappedf(target_facing_direction, PI/2)
	
	if facing_direction != target_facing_direction:
		facing_direction = lerp_angle(last_set_rotation, target_facing_direction, time_last_rotated/rotation_time)
	$SpringArm3D.rotation.y = facing_direction
	current_cam.rotation.y = facing_direction

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("select_primary"):
		var raymousepos = get_raymousepos()
		if raymousepos:
			target_pos = get_raymousepos()
			$Indicatorsphere.global_position = target_pos
		

func die():
	emit_signal("died")
	print("emmiting")

func respawn():
	pass
	

#TODO
"""
Make Player allign with ground

Add ability to push objects
"""
