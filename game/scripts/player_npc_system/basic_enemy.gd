class_name _BasicEnemy
extends _GameObject

## Can follow game objects or not.
@export var in_tracking_mode: bool = false

## Object to track (usually the player).
@export var tracking_object: Node2D = null

## Vector when not in tracking mode (not normalized).
var idle_vector: Vector2 = Vector2.LEFT

func _ready() -> void:
	super._ready()
	
	# TODO
	# Initialize variables.
	in_logic_control = true
	move_speed = 200
	pass

func _process(delta: float) -> void:
	super._process(delta)
	
	# -- Track Player Or Walk Straight--- #
	if (in_tracking_mode and tracking_object):
		move_vector = tracking_object.global_position - self.global_position
	else:
		move_vector = idle_vector
	pass
