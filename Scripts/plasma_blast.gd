extends Area3D

@export var speed := 5 
@onready var age = 0
@export var explode_age = 2.5
@export var target_group : String
@export var accent_color : String

var expand_time = 0.25
var max_size = 1

func _ready() -> void:
	var mat = Globals.glow_materials.get(accent_color, Globals.glow_materials["pink"])
	
	var mat_dup = mat.duplicate() as StandardMaterial3D
	mat_dup.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	var col = mat_dup.albedo_color
	col.a = 0.5
	mat_dup.albedo_color = col
	$MeshInstance3D.material_override = mat_dup

var speed_fac = 1
var _first_frame = true
var exploded = false
func _physics_process(delta: float) -> void:
	age += delta
	
	if _first_frame:
		_first_frame = false
		scale = Vector3.ZERO
		visible = true
		return
	elif age < expand_time:
		var scale_fac = lerpf(0, max_size, age/expand_time)
		scale = Vector3.ONE * scale_fac
		speed_fac = 5
	elif age < explode_age:
		scale = Vector3.ONE * max_size
		speed_fac = 1
	else:
		#print("explodepp")
		explode()
	position += global_basis * Vector3.FORWARD * speed * speed_fac * delta

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group(target_group):
		body.queue_free()
	explode()
	#wprint("explode")
	

func explode():
	if not exploded:
		exploded = true
		visible = false
		set_process(false)
		$AudioStreamPlayer3D.play()

func _on_audio_stream_player_3d_finished() -> void:
	queue_free()
	print("hahhaw")
