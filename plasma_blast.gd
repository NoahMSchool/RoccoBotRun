extends Area3D

@export var speed := 5.0
@onready var age = 0
@export var max_age = 5
@export var target_group : String
@export var accent_color : String

var materials = {
	"blue" : preload("res://Materials/blue_laser_mat.tres"), 
	"pink" : preload("res://Materials/pink_laser_mat.tres"),
	"red" : preload("res://Materials/red_laser_mat.tres"),

}

func _ready() -> void:
	var mat = materials.get(accent_color, materials["pink"])
	$MeshInstance3D.material_override = mat
	
func _physics_process(delta: float) -> void:
	age += delta
	position += global_basis * Vector3.FORWARD * speed * delta
	if age > max_age:
		queue_free()

func _on_body_entered(body: Node3D) -> void:
	explode()

func explode():
	queue_free()
