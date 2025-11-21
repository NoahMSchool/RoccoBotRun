extends CharacterBody3D

@export var max_health : int = 150.0
var health = max_health

@onready var health_component = $HealthComponent
@onready var damagable_component = $DamagableComponent
@onready var weapon = $LaserCannon
@onready var team_string = "enemy_robot"
@onready var team : Team

const ITEM_CRATE = preload("res://EnvironmentObjects/ItemCrate/item_crate.tscn")

func spot_player(player : CharacterBody3D):
	var player_pos = player.global_position
	$LaserCannon.use_item()
	look_at(player_pos, Vector3(0,1,0))
	rotation.x = clamp(rotation.x, -PI/8, PI/4)

func die():
	print("robot eliminated")
	make_death_crate()
	queue_free()
	

func _ready() -> void:
	team = Globals.get_team(team_string)
	if weapon:
		weapon.configure_item(team.accent_color)
	if health_component:
		health_component.health_out.connect(die)
	
	
		
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()
	
	$Vision.force_shapecast_update()
	if $Vision.is_colliding():
		spot_player($Vision.get_collider(0))
		
func make_death_crate():
	var death_crate = ITEM_CRATE.instantiate()
	death_crate.items[0] = (preload("res://Items/Weapons/LaserSword/laser_sword.tscn"))
	death_crate.global_position = global_position
	get_tree().get_root().add_child(death_crate)
