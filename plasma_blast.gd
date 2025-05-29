extends Area3D

@export var speed := 5 
@onready var age = 0
@export var max_age = 2.5
@export var target_group : String
@export var accent_color : String

var expand_time = 0.25
var max_size = 1

var materials = {
	"blue" : preload("res://Materials/blue_laser_mat.tres"), 
	"pink" : preload("res://Materials/pink_laser_mat.tres"),
	"red" : preload("res://Materials/red_laser_mat.tres"),
}

func _ready() -> void:
	var mat = materials.get(accent_color, materials["pink"])
	$MeshInstance3D.material_override = mat

var speed_fac = 1
var _first_frame = true
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
	elif age < max_age:
		scale = Vector3.ONE * max_size
		speed_fac = 1
	else: 
		queue_free()
	position += global_basis * Vector3.FORWARD * speed * speed_fac * delta
	
	
func _on_body_entered(body: Node3D) -> void:
	explode()

func explode():
	queue_free()
