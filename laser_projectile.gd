extends RayCast3D

@export var speed := 50.0
@onready var age = 0
@export var max_age = 0.5
@export var target_group : String
@export var accent_color : String
@export var damage : float
@onready var deal_damage_component : DealDamageComponent = $DealDamageComponent

func _ready() -> void:
	var mat = Globals.glow_materials.get(accent_color, Globals.glow_materials["pink"])
	$MeshInstance3D.material_override = mat
	$DealDamageComponent.target_group = target_group
	
func _physics_process(delta: float) -> void:
	age += delta
	position += global_basis * Vector3.FORWARD * speed * delta
	target_position = Vector3.FORWARD * speed * delta
	force_raycast_update()
	var collider = get_collider()
	if is_colliding():
		deal_damage_component.deal_damage(damage, collider)
		print("colliing with ", collider)
		queue_free()
	if age > max_age:
		#print("projectile out of range")                
		queue_free()
