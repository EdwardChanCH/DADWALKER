class_name _NPC
extends CharacterBody2D

## NPC world (handles model rotation and animation).
@export var npc_world_node: _NPCWorld = null

## Can accept scripted sequence input.
var can_sequence_control: bool = false

## Can accept NPC self input.
var can_self_control: bool = false

## Can accept player input.
var can_player_control: bool = false

## Movement vector. (not normalized)
var move_vector: Vector2 = Vector2.ZERO

## Movement speed.
var move_speed: float = 0

## NPC movement vector (not normalized).
var movement_vector: Vector2 = Vector2.ZERO

func _ready() -> void:
	# Check if missing export variables.
	if (not npc_world_node):
		push_error("Missing export variables in node '%s'." % [self.name])
	pass

func _process(delta: float) -> void:
	pass

func update_look_vector(direction: Vector2) -> void:
	if (direction != Vector2.ZERO):
		npc_world_node.target_look_vector = direction
	pass
