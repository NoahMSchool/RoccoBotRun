extends Node3D

class_name ProjectileComponent

@export var damage : int
@export var target_group : String
@export var accent_color : String

func apply_damage(body):
	if body.is_in_group(target_group):
		body.get_damaged(damage)
