extends Item
class_name Weapon

@export var max_ammo : int
@export var ammo_regen_rate : float
@onready var ammo = max_ammo
@onready var ammof = ammo
@export var fire_rate : float
@export var accent_color : String
@export var damage : int
@export var target_group = "enemies"

@onready var shot_time = 1/fire_rate

var attack_held = false

func configure_item():
	self.accent_color = "blue"
	#self.target_group = "enemies"

func fire():
	print("fire", self)

func get_ammo_percent() -> float:
	return ammof/max_ammo

func regen_ammo(delta : float) ->void:
	ammof = clamp(ammof+ammo_regen_rate*delta,0,max_ammo)
	ammo = int(ammof)
	
	
func _ready() -> void:
	pass
	
func _physics_process(delta: float) -> void:
	regen_ammo(delta)
