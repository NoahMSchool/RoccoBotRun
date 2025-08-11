extends Decal

@export var lifetime = 5


func _ready() -> void:
	$Timer.start(lifetime)

func _on_timer_timeout() -> void:
	queue_free()


#Add fading logic in process
