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
"""
@export var old_base: NodePath
@export var new_base: NodePath

func _run():
	var scene = get_editor_interface().get_edited_scene_root()
	if not scene:
		printerr("No scene open")
		return
	var player = scene.get_node("AnimationPlayer")
	if not player:
		printerr("No AnimationPlayer found under the root")
		return

	for anim_name in player.animations:
		var anim = player.get_animation(anim_name)
		for i in range(anim.get_track_count()):
			var path = anim.track_get_path(i)
			if String(path).begins_with(String(old_base)):
				# preserve the tail after old_base
				var tail = path.get_subnames().slice(old_base.get_name_count())
				var new_path = NodePath(new_base)+(tail)
				anim.track_set_path(i, new_path)
		# save the animation resource back to disk
		ResourceSaver.save(anim.resource_path, anim)

	# optionally save the scene so the AnimationPlayer ref updates
	ResourceSaver.save(scene.filename, scene)
	print("✅ Animation paths remapped from %s to %s" % [old_base, new_base])
"""
