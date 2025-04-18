extends Node3D

@export var max_radius := 5.0
var initial_radius := 0.1

@export var expand_time = 0.5
var elapsed = 0.0
var progress = 0.0

@export var explosion_power = 10

@onready var material  : StandardMaterial3D = $MeshInstance3D.get_active_material(0)


func _ready() -> void:	
	$MeshInstance3D.scale = Vector3.ONE * initial_radius
	$Area3D/CollisionShape3D.scale = Vector3.ONE * max_radius
	
	$ExpandTimer.start(expand_time)
	$Launch_Timer.start()
	
	$AudioStreamPlayer3D.play()

func _physics_process(delta: float) -> void:
	elapsed += delta
	progress = elapsed/expand_time
	$MeshInstance3D.scale = Vector3.ONE * lerp(initial_radius, max_radius, progress)
	var current_color = material.albedo_color
	current_color.a = lerp(1,0, progress)
	material.albedo_color = current_color
	"""
		var alpha = lerp(1.0, 0.0, progress)
		var mat : StandardMaterial3D = $MeshInstance3D.material_override
		if mat:
			var color = mat.albedo_color
			color.a = alpha
			mat.albedo_color = color
	"""	


		
func launch_objects():
	var bodies = $Area3D.get_overlapping_bodies()
	var range_bodies = []
	for body in bodies:
		var check_ray = PhysicsRayQueryParameters3D.create(global_transform.origin, body.global_transform.origin)
		check_ray.exclude = [self, body]
		var result = get_world_3d().direct_space_state.intersect_ray(check_ray)
		if !result:
			range_bodies.append(body)
			
	for body in range_bodies:
		if body is RigidBody3D:
			#print(body)
			var to_body = body.global_transform.origin - global_transform.origin
			var distance = to_body.length()
			
			var direction = to_body.normalized()
			var strength = explosion_power/distance
			body.apply_impulse(direction*strength)
	

func _on_expand_timer_timeout() -> void:	
	queue_free()




"""
TODO

Currently when debugging bodies multiple of the same appear, remove duplicates in range bodies if this is a problem
"""
