extends CharacterBody3D

@onready var health = 5

func spot_player(player : CharacterBody3D):
		var player_pos = player.global_position
		$LaserCannon.fire()
		look_at(player_pos, Vector3(0,1,0))
		rotation.x = clamp(rotation.x, -PI/8, PI/4)


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()
	
	$Vision.force_shapecast_update()
	if $Vision.is_colliding():
		spot_player($Vision.get_collider(0))
	
	
		
