extends PlanetWorld

@onready var stage_node : Node
@onready var stages : Array[Node] = []

@export var player_spawnpoint : Node3D

func _ready() -> void:
	super()
	stage_node = $Stages
	stages = stage_node.get_children()
	
	for cps in get_tree().get_nodes_in_group("check_point_spawns"):
		#cps.connect("checkpoint_reached", stage_reached)
		cps.connect("checkpoint_reached", self.stage_reached)

		#var err = cps.connect("checkpoint_reached", Callable(self, "stage_reached"))
	

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
		player_spawnpoint = spawn_object
	print("stageReached")

func player_die():
	print("player died")
	reset_level()

func reset_level():
	player_node.global_transform = player_spawnpoint.get_node("SpawnPos").global_transform
