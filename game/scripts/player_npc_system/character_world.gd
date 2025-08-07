class_name _CharacterWorld
extends Node3D

## Character scene root.
@export var character_node: _Character = null

## Target 2D look direction.
## Use this to rotate the character.
var target_look_vector: Vector2 = Vector2.DOWN

## [private] Current 2D look direction.
var __look_vector: Vector2 = Vector2.DOWN

## Slope of decay of smoothed look direction.
@export_range(1, 25, Globals.STEP, "suffix:/s")
var look_decay: float = 16

func _ready() -> void:
	# Check if missing export variables.
	if (not character_node):
		push_error("Missing export variables in node '%s'." % [self.name])
	
	# TODO test only
	# TODO set walking speed
	if character_node.has_method("start_walk"):
		character_node.call("start_walk")
	pass

func _physics_process(delta: float) -> void:
	# --- Update Look Direction --- #
	if (not __look_vector.is_equal_approx(target_look_vector)):
		__look_vector = __look_vector.slerp(target_look_vector, Globals.lerp_t(look_decay, delta))
		update_basis()
	pass

## Update the 3D rotation of the dragoon scene root.
func update_basis() -> void:
	var target_z: Vector3 = Vector3(__look_vector.x, 0, __look_vector.y)
	character_node.look_at(target_z, Vector3.UP, true)
	pass
