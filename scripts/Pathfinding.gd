extends Node
class_name Pathfinding

var astar : AStar2D = AStar2D.new()
var nodes : Array


func create_navigation_map(nodes_array : Array):
	self.nodes = nodes_array
	add_traversible_tiles()
	connect_traversible_tiles()
	
func add_traversible_tiles():
	for node_line in nodes:
		for node in node_line:
			astar.add_point(get_id_for_point(node), node.position_in_grid)


func connect_traversible_tiles():
	for x in range(nodes.size()):
		for y in range(nodes[x].size()):
			if x == 0 and y == 0:
				continue
				
			var current_node : GridNode = nodes[x][y]
			var l_node : GridNode = null
			var t_node : GridNode = null
			#var tl_node : GridNode = null
			
			var id := get_id_for_point(current_node)
			var l_id : int = -1
			var t_id : int = -1
			#var tl_id : int = -1
			
			if x == 0:
				t_node = nodes[x][y-1]
				t_id = get_id_for_point(t_node)
				astar.connect_points(id, t_id)
			elif y == 0:
				l_node = nodes[x-1][y]
				l_id = get_id_for_point(l_node)
				astar.connect_points(id, l_id)
			else:
				t_node = nodes[x][y-1]
				t_id = get_id_for_point(t_node)
				astar.connect_points(id, t_id)
				l_node = nodes[x-1][y]
				l_id = get_id_for_point(l_node)
				astar.connect_points(id, l_id)
				#tl_node = nodes[x-1][x-y]
				#tl_id = get_id_for_point(tl_node)
				#astar.connect_points(id, tl_id)


func update_navigation_map(structure_node : GridNode):
#	for node_line in nodes:
#		for node in node_line:
	#astar.set_point_disabled(get_id_for_point(structure_node), true)
	astar.remove_point(get_id_for_point(structure_node))


func test_path(from : GridNode, to : GridNode) -> bool:
	return astar.are_points_connected(get_id_for_point(from), get_id_for_point(to))


func get_path_from_gridnode(from : GridNode, to : GridNode) -> PoolVector2Array:
	if astar.are_points_connected(get_id_for_point(from), get_id_for_point(to)):
		return astar.get_point_path(get_id_for_point(from), get_id_for_point(to))
	var empty_arr : PoolVector2Array
	return empty_arr


func get_path_from_v3(from : Vector3, to : Vector3) -> PoolVector2Array:
	return get_path_from_gridnode(world_pos_to_grid(from), world_pos_to_grid(to))


func path_array_to_world(grid_path : PoolVector2Array) -> PoolVector2Array:
	var new_path : PoolVector2Array
	for point in grid_path:
		new_path.append(grid_to_world_pos(point))
	return new_path


func grid_to_world_pos(grid_position : Vector2) -> Vector2:
	var node_size = nodes[0][0].node_mesh_size
	var node_half = Vector2(node_size.x / 2, node_size.y / 2)
	var new_pos = Vector2(grid_position.x * node_size.x + node_half.x, grid_position.y * node_size.y + node_half.y)
	return new_pos


func world_pos_to_grid(position : Vector3) -> GridNode:
	for node_line in nodes:
		for node in node_line:
			if int(position.x) / int(node.node_mesh_size.x) == int(node.position_in_grid.x) and int(position.z) / int(node.node_mesh_size.y) == int(node.position_in_grid.y):
				return node
	
	return null


func get_next_path_point(from : GridNode, to : GridNode) -> Vector2:
	var path : PoolVector2Array = get_path_from_gridnode(from, to)
	if path.size():
		if path.size() > 1:
			return path[1]
		return path[0]
	return Vector2.ZERO


func get_id_for_point(node : GridNode) -> int:
	var id : int
	var str_id : String
	str_id = str(node.position_in_grid.x)
	str_id += str(node.position_in_grid.y)
	id = int(str_id)
	return id
