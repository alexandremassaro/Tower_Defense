extends KinematicBody
class_name Mob


export var speed = 10.0

var velocity : Vector3
var waypoints : Array
onready var pathfinding := get_parent().get_node("Pathfinding")
var path_points : PoolVector2Array

func _physics_process(_delta):
	if self.waypoints.size():
		var _current_waypoint = waypoints[0] as Area
		look_at(_current_waypoint.translation, Vector3.UP)
		velocity = translation.direction_to(get_next_path_point()).normalized() * speed
		move_and_slide(velocity)
	else:
		queue_free()


func remove_waypoint(waypoint : Waypoint):
	if waypoint.id == waypoints[0].id:
		waypoints.remove(0)
		if waypoints.size():
			path_points = get_path_to_next_waypoint()


func get_next_path_point() -> Vector3:
	var from : GridNode = pathfinding.world_pos_to_grid(translation)
	var to : GridNode = pathfinding.world_pos_to_grid(waypoints[0].translation)
	var path_point : Vector2 = pathfinding.get_next_path_point(from, to)
	
	if path_point == Vector2.ZERO:
		return translation
	
	path_point = pathfinding.grid_to_world_pos(path_point)
	
	return Vector3(path_point.x, translation.y, path_point.y)
	
#	path_points = get_path_to_next_waypoint()
#	if path_points.size():
#		path_points.remove(0)
#	return Vector3(path_points[0].x, translation.y, path_points[0].y)


func get_path_to_next_waypoint() -> PoolVector2Array:
	var next_path : PoolVector2Array = pathfinding.get_path_from_v3(translation, waypoints[0].translation)
#	next_path[next_path.size() - 1].x = waypoints[0].translation.x
#	next_path[next_path.size() - 1].y = waypoints[0].translation.z
	next_path.append(Vector2(waypoints[0].translation.x, waypoints[0].translation.z))
	next_path = pathfinding.path_array_to_world(next_path)
	return next_path


func initialize(start_position : Vector3, goto_waypoints : Array):
	self.waypoints = goto_waypoints
	#self.pathfinding = get_parent().get_node("Pathfinding")
	
#	randomize()
#	var sorteio = randi() % 100
#	if sorteio < 50:
#		self.waypoints.invert()
	
	translation = start_position
	
	if waypoints.size():
		path_points = get_path_to_next_waypoint()
	
