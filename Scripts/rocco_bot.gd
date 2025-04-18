
extends CharacterBody3D

const SPEED = 5.0
const MAX_JUMP = 4.5
var super_jump = false
var jump_power = 5
var current_speed = SPEED

var mouse_delta = Vector2.ZERO

@export var cam_sens = 0.00025

func _ready() -> void:
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	pass
	
func _physics_process(delta: float) -> void:
	current_speed = SPEED
	
	#preventing looking behind objects
	$CamPivot/Camera3D.position = lerp($CamPivot/Camera3D.position, $CamPivot/SpringArm3D/CamPos.position, 15*delta)
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	#jumping
	if Input.is_action_just_released("jump") and is_on_floor():
		velocity.y = clamp(jump_power, 5, 9)
	if Input.is_action_pressed("jump") and is_on_floor():
		jump_power += delta*25
		current_speed /= 2
	else:
		jump_power = 0

	#get movement direction
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction = ($CamPivot.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if input_dir != Vector2.ZERO:
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
	
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	#Rotating Cam Pivot based on mouse0
	if event is InputEventMouseMotion:
		$CamPivot.rotation.y -= event.relative.x*cam_sens
		$CamPivot.rotation.x -= event.relative.y*cam_sens
		$CamPivot.rotation.x = clamp($CamPivot.rotation.x, -PI/4, PI/8)
		

#TODO
"""
Make Player allign with ground

Add ability to push objects
"""
