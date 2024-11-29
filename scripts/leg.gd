extends Node2D

@onready var main = get_node('/root/main')

@export var animation_secs = 1.0
@export var eject_curve: Curve
@export var max_length = 30.0

var shape:Node2D
var shape_position:Node2D
var limb_target: Node2D

var vector_delta: Vector2

var start_time: float
var initialized = false

func _ready() -> void:
	shape = get_node('shape')
	shape_position = get_node('shape_position')

	shape.reparent(get_parent())

func _physics_process(_delta: float) -> void:		
	if !initialized:
		rotation_degrees = -get_parent().rotation_degrees
		start_time = main.curr_secs()
		print(limb_target.global_position)
		vector_delta = limb_target.global_position - global_position
		if vector_delta.length() > max_length:
			vector_delta *= max_length / vector_delta.length()
		initialized = true

	var weight = (main.curr_secs() - start_time) * (1.0 / animation_secs)

	if weight >= 1.0:
		shape.queue_free()
		queue_free()

	shape_position.position = lerp(Vector2.ZERO, vector_delta, eject_curve.sample(weight))

	shape.global_position = shape_position.global_position

