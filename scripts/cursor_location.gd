extends Node2D

@export var camera: Camera2D

func _process(_delta: float) -> void:
	global_position = get_global_mouse_position()
