extends Node


export var camera_distance = 18.0
onready var viewport = get_viewport()
onready var camera_pivot = $CameraPivot
onready var camera = $CameraPivot/Camera


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)


func _physics_process(_delta):
	if viewport.get_mouse_position().x <= viewport.get_visible_rect().size.x * 0.1:
		camera_pivot.translation.x -= 0.5
	if viewport.get_mouse_position().x >= viewport.get_visible_rect().size.x - viewport.get_visible_rect().size.x * 0.1:
		camera_pivot.translation.x += 0.5
	if viewport.get_mouse_position().y <= viewport.get_visible_rect().size.y * 0.1:
		camera_pivot.translation.z -= 0.5
	if viewport.get_mouse_position().y >= viewport.get_visible_rect().size.y - viewport.get_visible_rect().size.y * 0.1:
		camera_pivot.translation.z += 0.5


func _unhandled_input(event):
	if event.is_action_pressed("zoom_in"):
		zoom_in()
	elif event.is_action_pressed("zoom_out"):
		zoom_out()


func zoom_in():
	camera_distance -= 1.0
	camera.translation.z = camera_distance


func zoom_out():
	camera_distance += 1.0
	camera.translation.z = camera_distance
