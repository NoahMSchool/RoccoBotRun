extends Node3D

@export var max_radius := 5.0
var initial_radius := 0.1

@export var expand_time = 0.5
var elapsed = 0.0
var progress = 0.0

@export var explosion_power = 50
@export var damage = 150

@onready var material  : StandardMaterial3D = $MeshInstance3D.get_active_material(0)
var accent_color = "blue"

var mat = Globals.glow_materials.get(accent_color, Globals.glow_materials["pink"])
var mat_dup = mat.duplicate() as StandardMaterial3D


func _ready() -> void:	
	$MeshInstance3D.scale = Vector3.ONE * initial_radius
	$Area3D/CollisionShape3D.scale = Vector3.ONE * max_radius
	
	$ExpandTimer.start(expand_time)
	$Launch_Timer.start()
	
	$AudioStreamPlayer3D.play()
	
	mat_dup.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	$MeshInstance3D.material_override = mat_dup
	
	#var col = mat_dup.albedo_color
	#col.a = 0.5
	#mat_dup.albedo_color = col

func _physics_process(delta: float) -> void:
	elapsed += delta
	progress = elapsed/expand_time
	$MeshInstance3D.scale = Vector3.ONE * lerp(initial_radius, max_radius, progress)
	
	var col = mat_dup.albedo_color
	col.a = lerp(1,0, progress)
	mat_dup.albedo_color = col
		
func _on_launch_timer_timeout():
	var bodies = $Area3D.get_overlapping_bodies()
	var range_bodies = []
	for body in bodies:
		var check_ray = PhysicsRayQueryParameters3D.create(global_transform.origin, body.global_transform.origin)
		check_ray.exclude = [self, body]
		var result = get_world_3d().direct_space_state.intersect_ray(check_ray)
		if !result or result.position == body.global_transform.origin:
			range_bodies.append(body)

	for body in range_bodies:
		var to_body = body.global_transform.origin - global_transform.origin
		var distance = to_body.length()
		var direction = to_body.normalized()
		if body is RigidBody3D:
			var strength = explosion_power/distance**2
			body.apply_impulse(direction*strength)
		$DealDamageComponent.deal_damage(2.5*damage/distance**2, body)


func _on_expand_timer_timeout() -> void:	
	queue_free()
