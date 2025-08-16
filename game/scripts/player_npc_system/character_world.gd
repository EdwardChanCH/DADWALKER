class_name _CharacterWorld
extends Node3D

## Character scene root.
@export var character_node: _Character = null

## Target 2D look direction.
## Use this to rotate the character.
var target_look_vector: Vector3 = Vector3.BACK

## Current 3D look direction.
var look_vector: Vector3 = Vector3.BACK

## Slope of decay of smoothed look direction.
@export_range(1, 25, Globals.STEP, "suffix:/s")
var look_decay: float = 16

func _ready() -> void:
	# Check if missing export variables.
	if (not character_node):
		push_error("Missing export variables in node '%s'." % [self.name])
	
	# Plays idle animation by default.
	start_idle()
	pass

func _physics_process(delta: float) -> void:
	# --- Update Look Direction --- #
	if (not look_vector.is_equal_approx(target_look_vector)):
		look_vector = look_vector.slerp(target_look_vector, Globals.lerp_t(look_decay, delta))
		character_node.look_at(look_vector, Vector3.UP, true)
	pass

# --- Functions --- #

## Fake animation.
func start_death() -> void:
	# Tilt upwards.
	target_look_vector = target_look_vector * 0.01 + Vector3.UP
	pass

# --- Relay Functions --- #

# Mostly for backwards compatibility...

func update_health(new_health: int) -> void:
	character_node.update_health(new_health)
	pass

func start_walk() -> void:
	character_node.start_walk()
	pass

func start_idle() -> void:
	character_node.start_idle()
	pass

func start_t_pose() -> void:
	character_node.start_t_pose()
	pass

func start_handsup() -> void:
	character_node.start_handsup()
	pass

func start_backflip(reversed: bool) -> void:
	pass

func start_bullet() -> void:
	character_node.start_bullet()
	pass

func start_tomato() -> void:
	character_node.start_tomato()
	pass
