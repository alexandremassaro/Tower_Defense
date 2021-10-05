extends Area
class_name Waypoint

export var id : int

func _ready():
	pass


func _on_Waypoint_body_entered(body):
	if body.is_in_group("mobs"):
#		var _current_mob = body as Mob
		body.remove_waypoint(self)
