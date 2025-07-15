extends Node3D
class_name ShootComponent

@export var projectile : Resource

@export var bloom_angle : float = 0
#Multiples of PI e.g:PI/72

@export var damage : float
@export var target_group = "enemies"
@export var accent_color : String

func shoot(base_transform):
	self.global_transform = base_transform
	var projectile = projectile.instantiate()
	projectile.target_group = target_group
	projectile.accent_color = self.accent_color
	projectile.damage = damage
	projectile.global_position = global_position
	get_tree().current_scene.add_child(projectile)
	
	#Adding Bloom
	var vertical_spread_angle = randf_range(-bloom_angle, bloom_angle)
	var vertical_spread_dir = Basis(global_transform.basis.x, vertical_spread_angle)

	var horizontal_spread_angle = randf_range(-bloom_angle, bloom_angle)
	var horizontal_spread_dir = Basis(global_transform.basis.y, horizontal_spread_angle)
	
	var base_dir = -global_transform.basis.z

	var result_dir = vertical_spread_dir * horizontal_spread_dir * base_dir

	projectile.look_at(global_transform.origin+result_dir, Vector3.UP)
