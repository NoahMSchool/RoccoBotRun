@tool
extends EditorScript

#var old_path = "RoccoBotRig/Skeleton3D"
var old_path = "Object/Skeleton"
var new_path = "Object/Skeleton3D"

func _run() -> void:
	var scene = get_scene()
	var anim_player : AnimationPlayer = scene.get_node_or_null("AnimationPlayer")
	
	if !anim_player:
		print("no anim player found")
		return
	
	for anim_name in anim_player.get_animation_list():
		var anim : Animation = anim_player.get_animation(anim_name)
		print(anim_name)
		for i in range(anim.get_track_count()):
			var path : NodePath = anim.track_get_path(i)
			print(String(path))
			if String(path).begins_with(old_path):
				var tail = String(path).get_slice(old_path, 1)
				print(tail)
				var track_new_path = new_path + tail
				print(path, track_new_path)
				anim.track_set_path(i, track_new_path)
