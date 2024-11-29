extends Node

var _curr_secs:float
var _delta_secs:float

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

