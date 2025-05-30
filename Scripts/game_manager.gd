extends Node

signal reset_level

@onready var stage_node : Node
@onready var player_node : Node3D
@onready var stages : Array[Node] = []

func _ready() -> void:
	stage_node = get_tree().get_root().get_node("GameRoot/SpaceCity/Stages")
	player_node = get_tree().get_root().get_node("GameRoot/RoccoBot")
	stages = stage_node.get_children()
	
	for cps in get_tree().get_nodes_in_group("check_point_spawns"):
		#cps.connect("checkpoint_reached", stage_reached)
		cps.connect("checkpoint_reached", self.stage_reached)

		var err = cps.connect("checkpoint_reached", Callable(self, "stage_reached"))
	
func player_die():
	print("die")
	emit_signal("reset_level")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("FreeMouse"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if event.is_action_pressed("Die"):
		player_die()	
	
	if event.is_action_pressed("plus"):
		pass

func stage_reached(checkpoint: Node3D) -> void:
	stage_node = checkpoint.get_node("..")
	print("Stage ", stage_node.name)
	for stage in stages:
		var stage_object = stage.get_node("StageObjects")
		if stage_object:
			stage_object.visible = (stage == stage_node)

	var spawn_object = stage_node.get_node("CheckPointSpawn")
	print("Spawner ", spawn_object.name)
	if spawn_object && player_node:
		player_node.spawnpoint = spawn_object
	print("stageReached")
