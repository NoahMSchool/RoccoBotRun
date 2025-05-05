extends Node3D

signal checkpoint_reached(checkpoint: Node3D)

@export var barrier : StaticBody3D

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		checkpoint_reached.emit(self)
		body.spawnpoint = self
	if barrier:
		barrier.get_node("CollisionShape3D").set_deferred("disabled", false)
		barrier.get_node("MeshInstance3D").visible = true
	$CheckPointRing/AnimationPlayer.play("ringFly")
	
	
