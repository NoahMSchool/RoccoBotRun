extends Node3D

var iss_url = "http://api.open-notify.org/iss-now.json"
var joke_url = "https://official-joke-api.appspot.com/jokes/programming/random"

@onready var old_angle = 0
@onready var new_angle = 0
@onready var time_since_update = 0
	
func call_api():
	$HTTPRequest.request(iss_url)


func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	print("result : ", result)
	print("response_code : ", response_code)
	
	var body_string = body.get_string_from_utf8()
	var json = JSON.parse_string(body_string)
	
	old_angle = new_angle
	time_since_update = 0
	var longitude = float(json["iss_position"]["longitude"])
	
	new_angle = deg_to_rad(longitude)


func _process(delta: float) -> void:
	
	time_since_update += delta
	var new_rot = lerp_angle(old_angle, new_angle, time_since_update/5)
	rotation.y = new_rot
	
func _on_timer_timeout() -> void:
	call_api()
	
