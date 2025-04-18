extends RayCast3D

@export var speed := 50.0
@onready var age = 0
@export var max_age = 100

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	age += 1
	position += global_basis * Vector3.FORWARD * speed * delta
	target_position = Vector3.FORWARD * speed * delta
	force_raycast_update()
	var collider = get_collider()
	if is_colliding():
		#print("laser collision", collider)
		queue_free() 
	if age > max_age:
		#print("projectile out of range")                
		queue_free()
