extends Node

var _curr_secs:float
var _delta_secs:float

@export_flags_2d_physics var basic_layer

@onready var world = get_node('/root/main/world')

func _process(_delta: float) -> void:
	var time_elapsed = float(Time.get_ticks_msec()) / 1000.0;
	_delta_secs = time_elapsed - _curr_secs
	_curr_secs = time_elapsed

func create_node(prefab, parent):
	var new_node = prefab.instantiate()
	parent.add_child(new_node)
	new_node.position = Vector2.ZERO;
	return new_node

	
func curr_secs():
	return _curr_secs;
	
func delta_secs():
	return _delta_secs;


func get_nodes_in_shape(collider, transform, collision_mask = 0, motion = Vector2.ZERO):
	var shape = PhysicsShapeQueryParameters2D.new()
	shape.shape = collider.shape;
	shape.transform = transform
	shape.collide_with_areas = false
	if collision_mask != 0:
		shape.collision_mask = collision_mask
	else:
		shape.collision_mask = basic_layer
	if motion != Vector2.ZERO:
		shape.motion = motion
	var collisions = world.get_world_2d().direct_space_state.intersect_shape(shape);
	if collisions == null:
		return([])
	
	var nodes = []
	for collision in collisions:
		var node = collision['collider']
		nodes.append(node)
	return nodes
