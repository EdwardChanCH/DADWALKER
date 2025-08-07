class_name _DragoonWorld
extends _NPCWorld

## Dragoon scene root.
@export var dragoon_node: _Dragoon = null

## Animation player of the Dragoon.
var animation_node: AnimationPlayer = null

## Target 2D look direction.
## Use this to rotate the character.
var target_look_vector: Vector2 = Vector2.DOWN

## [private] Current 2D look direction.
var __look_vector: Vector2 = Vector2.DOWN

## Lock the look direction.
var is_look_vector_locked: bool = false

## Slope of decay of smoothed look direction.
@export_range(1, 25, Globals.STEP, "suffix:/s")
var look_decay: float = 16

func _ready() -> void:
	# Check if missing export variables.
	if (not dragoon_node):
		push_error("Missing export variables in node '%s'." % [self.name])
	
	animation_node = dragoon_node.animation_player
	
	# TODO test only
	# TODO set walking speed
	animation_node.play("dragoon_walk")
	pass

func _physics_process(delta: float) -> void:
	# --- Update Look Direction --- #
	if (not __look_vector.is_equal_approx(target_look_vector)):
		__look_vector = __look_vector.slerp(target_look_vector, Globals.lerp_t(look_decay, delta))
		update_basis()
	pass

## Update the 3D rotation of the dragoon scene root.
func update_basis() -> void:
	var target_z: Vector3 = Vector3(__look_vector.x, 0.0, __look_vector.y)
	dragoon_node.look_at(target_z, Vector3.UP, true)
	pass
