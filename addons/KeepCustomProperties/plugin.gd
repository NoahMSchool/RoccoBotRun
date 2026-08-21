@tool
extends EditorPlugin


func _enable_plugin() -> void:
	pass
	# Add autoloads here.
	#print("enabling")


func _disable_plugin() -> void:
	pass
	# Remove autoloads here.
	#print("disabling")

var extension = preload("res://addons/KeepCustomProperties/keep_custom_properties.gd").new()

func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	#print("entering tree")
	GLTFDocument.register_gltf_document_extension(extension)

func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	GLTFDocument.unregister_gltf_document_extension(extension)
	#print("removing from tree")
