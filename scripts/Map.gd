extends Spatial

export (Material) var color_grid1 = preload("res://assets/map_materials/Node_01.tres")
export (Material) var color_grid2 = preload("res://assets/map_materials/Node_03.tres")
export (Material) var color_grid3 = preload("res://assets/map_materials/Node_04.tres")

export (PackedScene) var node_scene = preload("res://assets/map_structures/Node.tscn")
export (PackedScene) var mob_scene = preload("res://assets/actors/Mob.tscn")


var waypoints : Array


export var map_size = Vector2(37, 37)

var nodes = []

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		if $MobTimer.is_stopped():
			$MobTimer.start()
		else:
			$MobTimer.stop()

func _ready():
	for object in self.get_children():
		if object.is_in_group("waypoints"):
			waypoints.append(object as Area)
			
	for x in range(map_size.x):
		var node_line = []
		for z in range(map_size.y):
			var node_position = translation
			node_position.x += x
			node_position.z += z
			
			var node  = node_scene.instance()
			node_line.append(node)
			add_child(node)
			
			var material : Material
			
			if not int(node_position.z) % 2:
				if not int(node_position.x) % 2:
					material = color_grid1
				else:
					material = color_grid2
			else:
				if not int(node_position.x) % 2:
					material = color_grid2
				else:
					material = color_grid1
			
			node.initialize(node_position, material)
		
		nodes.append(node_line)
	
	$Pathfinding.create_navigation_map(nodes)


func _on_MobTimer_timeout():
	var mob  = mob_scene.instance()
	
	var mob_spawn_location = $Spawner/SpawnPath/SpawnLocation
	mob_spawn_location.unit_offset = randf()
	mob_spawn_location.translation.x = mob_spawn_location.translation.x + $Spawner.translation.x
	mob_spawn_location.translation.z = mob_spawn_location.translation.z + $Spawner.translation.z
	
	add_child(mob)
	mob.initialize(mob_spawn_location.translation, waypoints.duplicate())
