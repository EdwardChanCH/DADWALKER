class_name _GameObject
extends CharacterBody2D

## Character world (handles model rotation and animation).
@export var character_world_node: _CharacterWorld = null

## Can accept scripted sequence input.
var can_sequence_control: bool = false

## Can accept self input.
var can_self_control: bool = false

## Can accept player input.
var can_player_control: bool = false

## Movement vector. (not normalized)
var move_vector: Vector2 = Vector2.ZERO

## Movement speed.
var move_speed: float = 0

## Movement vector (not normalized).
var movement_vector: Vector2 = Vector2.ZERO

func _ready() -> void:
	# Check if missing export variables.
	if (not character_world_node):
		push_error("Missing export variables in node '%s'." % [self.name])
	pass

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass

func update_look_vector(direction: Vector2) -> void:
	if (direction != Vector2.ZERO):
		character_world_node.target_look_vector = direction
	pass
