class_name _GameObject
extends CharacterBody2D

## Character world (handles model rotation and animation).
@export var character_world_node: _CharacterWorld = null

## Hit detector.
@export var hit_detector_node: Area2D = null

## Projectile scene as weapon.
@export var projectile_scene: PackedScene = null

## Projectile speed.
@export var projectile_speed: float = 50

## Max health.
@export var max_health: int = 1

# TODO
## Current health.
@export var current_health: int = 1 :
	get:
		return current_health
	set(value):
		current_health = value
		_on_health_changed(value)

## Delay before health can regenerate.
@export_range(0, 100, Globals.STEP, "suffix:s")
var health_regen_delay: float = 3

## Time needed to regenerate 1 hp.
@export_range(0, 100, Globals.STEP, "suffix:s/hp")
var health_regen_period: float = 1

## Can accept scripted sequence input.
var in_sequence_control: bool = false

## Can accept self input.
var in_logic_control: bool = false

## Can accept player input.
var in_player_control: bool = false

## Movement vector. (not normalized)
var move_vector: Vector2 = Vector2.ZERO

## Movement speed.
var move_speed: float = 0

## Extra movement velocity (for pushing other game objects)
var move_velocity_extra

func _ready() -> void:
	# Check if missing export variables.
	if (not character_world_node
		or not projectile_scene):
		push_error("Missing export variables in node '%s'." % [self.name])
	
	# Initialize health bar.
	_on_health_changed(current_health)
	pass

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	var move_direction: Vector2 = move_vector.normalized()
	
	self.velocity = move_direction * move_speed
	self.move_and_slide()
	
	update_look_vector(move_direction)
	pass

func update_look_vector(direction: Vector2) -> void:
	if (direction != Vector2.ZERO):
		character_world_node.target_look_vector = Vector3(direction.x, 0, direction.y)
	pass

func _on_health_changed(new_health: int) -> void:
	if (not Engine.is_editor_hint()):
		if (new_health > 0):
			character_world_node.update_health(new_health)
		else:
			character_world_node.update_health(0)
	pass
