extends RigidBody2D

@export var torque_mult = 10000.0
@export var max_angular_velocity = 3.0

@export var limb_target_prefab: PackedScene
@export var leg_prefab: PackedScene

@export var cursor_location: Node2D
@export var limb_targets: Node2D

@onready var main = get_node('/root/main')


var torque_input := 0

func _physics_process(delta: float) -> void:
	handle_controls(delta)

	if torque_input != 0:
		angular_velocity += torque_input * torque_mult
	else:
		angular_velocity = angular_velocity * 0.9
	angular_velocity = clamp(angular_velocity, -max_angular_velocity, max_angular_velocity);


func handle_controls(_delta):
	torque_input = 0

	if Input.is_action_pressed('move_left'):
		torque_input -= 1
	if Input.is_action_pressed('move_right'):
		torque_input += 1

	if Input.is_action_just_pressed('eject_leg'):
		var new_limb_target = main.create_node(limb_target_prefab, limb_targets)
		new_limb_target.global_position = cursor_location.global_position

		var new_leg = main.create_node(leg_prefab, self)
		new_leg.global_position = global_position
		new_leg.limb_target = new_limb_target
	

	
