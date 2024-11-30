extends Node2D

@onready var main = get_node('/root/main')

@export var animation_secs = 1.0
@export var eject_curve: Curve
@export var max_length = 30.0
@export var jump_power_mult = 5.0
@export_flags_2d_physics var ground_layer

var shape:Node2D
var shape_position:Node2D
var limb_target: Node2D
var player:RigidBody2D

var vector_delta: Vector2

var start_time: float
var initialized = false
var sample_history = [0.0,0.0]

func _ready() -> void:
	shape = get_node('shape')
	shape_position = get_node('shape_position')
	player = get_parent()

	shape.reparent(player)

func _physics_process(_delta: float) -> void:		
	if !initialized:
		rotation_degrees = -get_parent().rotation_degrees
		start_time = main.curr_secs()
		vector_delta = limb_target.global_position - global_position
		if vector_delta.length() > max_length:
			vector_delta *= max_length / vector_delta.length()
		initialized = true

	var weight = (main.curr_secs() - start_time) * (1.0 / animation_secs)

	if weight >= 1.0:
		shape.queue_free()
		queue_free()

	var prev_pos = shape_position.global_position

	var sample = eject_curve.sample(weight)
	shape_position.position = lerp(Vector2.ZERO, vector_delta, sample)

	sample_history.pop_back()
	sample_history.insert(0, sample)

	if sample_history[0] > sample_history[1]:
		if len(main.get_nodes_in_shape(shape, shape_position.global_transform, ground_layer)) != 0:
			var force_to_add = (player.global_position - shape_position.global_position).normalized() * (prev_pos-shape_position.global_position).length() * jump_power_mult
			player.linear_velocity += force_to_add

	shape.global_position = shape_position.global_position
