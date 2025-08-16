class_name _GameObject
extends CharacterBody2D

## Character world (handles model rotation and animation).
@export var character_world_node: _CharacterWorld = null

## Hit detector.
@export var hit_detector_node: Area2D = null

## Projectile scene as weapon.
@export var projectile_scene: PackedScene = null

## Projectile speed.
@export var projectile_speed: float = 100

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

## Can follow game objects or not.
@export var in_tracking_mode: bool = false

## Object to track (usually the player).
@export var tracking_object: Node2D = null

## Vector when not in tracking mode (not normalized).
@export var idle_vector: Vector2 = Vector2.LEFT

## Movement vector. (not normalized)
var move_vector: Vector2 = Vector2.ZERO

## Movement speed.
var move_speed: float = 0

## Movement velocity from being pushed.
var push_velocity: Vector2 = Vector2.ZERO

## Movement speed from being pushed.
@export var push_speed: float = 3000

## Minimum push speed, squared (for push speed to dominate).
@export var push_speed_sq_min: float = 400

## Slope of decay of smoothed push deceleration.
@export_range(1, 25, Globals.STEP, "suffix:/s")
var push_decay: float = 10

## Fade out timer.
var __fade_out_timer: float = 0

var __scl: int = 0
var __scm: int = 0
var __hcl: int = 0
var __hcm: int = 0

func _ready() -> void:
	# Check if missing export variables.
	if (not character_world_node
		or not projectile_scene):
		push_error("Missing export variables in node '%s'." % [self.name])
	
	__scl = self.collision_layer
	__scm = self.collision_mask
	__hcl = hit_detector_node.collision_layer
	__hcm = hit_detector_node.collision_mask
	
	# Initialize health bar.
	_on_health_changed(current_health)
	pass

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if (current_health <= 0):
		__fade_out_timer += delta
		self.modulate.a = 1 - clampf(__fade_out_timer - 0.5, 0, 1)
		if is_zero_approx(self.modulate.a):
			self.queue_free()
	pass

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	var move_direction: Vector2 = move_vector.normalized()
	
	if (push_velocity.length_squared() > push_speed_sq_min):
		self.velocity = push_velocity
	else:
		self.velocity = move_direction * move_speed + push_velocity
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
			_on_death()
	pass

func _on_death() -> void:
	# Disable collisions.
	self.collision_layer = 0
	self.collision_mask = 0
	hit_detector_node.collision_layer = 0
	hit_detector_node.collision_mask = 0
	
	# Disable controls.
	in_sequence_control = false
	in_logic_control = false
	in_player_control = false
	
	# Play death animation.
	character_world_node.start_death()
	pass
