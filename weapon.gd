extends Item
class_name Weapon

@export var max_ammo : int
@export var ammo_regen : float
@onready var ammo = max_ammo
@onready var ammof = ammo
@export var accent_color : String

@export var target_group = "enemies"



func regen_ammo(delta : float) ->void:
	ammof = clamp(ammof+ammo_regen*delta,0,max_ammo)
	ammo = int(ammof)
	
	
func _ready() -> void:
	pass
	
func _physics_process(delta: float) -> void:
	regen_ammo(delta)
