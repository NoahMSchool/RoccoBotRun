extends RayCast3D

@export var speed := 50.0
@onready var age = 0
@export var max_age = 0.5
@export var target_group : String
@export var accent_color : String
@export var damage : float
@onready var deal_damage_component : DealDamageComponent = $DealDamageComponent

const decal_node = preload("res://Items/Weapons/LaserCannon/bullet_hole_decal.tscn")


func _ready() -> void:
	var mat = Globals.glow_materials.get(accent_color, Globals.glow_materials["pink"])
	$MeshInstance3D.material_override = mat
	$DealDamageComponent.target_group = target_group
	
func _physics_process(delta: float) -> void:
	age += delta
	
	force_raycast_update()
	var collider = get_collider()
	if is_colliding():
		deal_damage_component.deal_damage(damage, collider)
		var decal = decal_node.instantiate()
		
		decal.global_position =  get_collision_point()
		decal.global_rotation = get_collision_normal()
		#print(get_collision_normal(), get_collision_normal().rotated(Vector3.UP, PI/2))
		#decal.rotate_z(PI/2)
		var basis = Basis()
		basis = basis.looking_at(get_collision_normal(), Vector3.UP)
		basis = basis.rotated(basis.x, PI)
		decal.global_transform.basis = basis
		
		decal.global_transform.origin = get_collision_point() + get_collision_normal() * 0.01
		get_tree().current_scene.add_child(decal)
		
		queue_free()
		
	if age > max_age:
		#print("projectile out of range")                
		queue_free()
		
	position += global_basis * Vector3.FORWARD * speed * delta
	target_position = Vector3.FORWARD * speed * delta
