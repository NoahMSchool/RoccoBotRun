extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	return
	for platform in get_children():
		if platform.has_node("AnimationPlayer"):
			var anim_player = platform.get_node("AnimationPlayer")
			var animation_name = "z_platform_move"
			var anim = anim_player.get_animation(animation_name)
			if anim:
				var offset = randf_range(0, anim.length)
				anim_player.play(animation_name)
				anim_player.seek(offset, true)
