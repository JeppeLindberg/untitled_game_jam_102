extends Node2D

@export var targets: Array[Node2D]


func _process(delta: float) -> void:
	var avg_global_pos = Vector2.ZERO
	for target in targets:
		avg_global_pos += target.global_position
	global_position = lerp(global_position, avg_global_pos / len(targets), delta*10.0)
