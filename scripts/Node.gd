extends Spatial
class_name GridNode

onready var ground_mesh = $StaticBody/MeshInstance
export (PackedScene) var tower = preload("res://assets/map_structures/tower.tscn")

var structures := []
var mouse_over := false
var position_in_grid : Vector2
var node_mesh_size : Vector2

func initialize(position : Vector3, material : Material):
	translation = position
	position_in_grid = Vector2(position.x, position.z)
	translation.x *= ground_mesh.mesh.size.x
	node_mesh_size.x = ground_mesh.mesh.size.x
	translation.z *= ground_mesh.mesh.size.z
	node_mesh_size.y = ground_mesh.mesh.size.z
	
	ground_mesh.set_material_override(material)


func _physics_process(_delta):
	if Input.is_action_just_pressed("add_tower") and mouse_over:
		add_new_structure()


func add_new_structure():
	var new_tower = tower.instance()
	structures.append(new_tower)
	self.add_child(new_tower)
	var pathfinding := get_parent().get_node("Pathfinding")
	pathfinding.update_navigation_map(self)

func _on_StaticBody_mouse_entered():
	$StaticBody/MeshMouseOver.visible = true
	mouse_over = true


func _on_StaticBody_mouse_exited():
	$StaticBody/MeshMouseOver.visible = false
	mouse_over = false
