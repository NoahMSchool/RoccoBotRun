extends CharacterBody3D

@export var max_health : int = 150.0
var health = max_health

@onready var health_component = $HealthComponent
@onready var damagable_component = $DamagableComponent


func spot_player(player : CharacterBody3D):
	var player_pos = player.global_position
	$LaserCannon.use_item()
	look_at(player_pos, Vector3(0,1,0))
	rotation.x = clamp(rotation.x, -PI/8, PI/4)

func die():
	print("robot eliminated")
	queue_free()


func _ready() -> void:
	if health_component:
		health_component.health_out.connect(die)
		
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()
	
	$Vision.force_shapecast_update()
	if $Vision.is_colliding():
		spot_player($Vision.get_collider(0))
