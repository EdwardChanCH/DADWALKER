class_name _TestCubeWorld
extends Node3D
# TODO test only.

@export var cube_node: MeshInstance3D = null

func _ready() -> void:
	# Check if missing export variables.
	if (not cube_node):
		push_error("Missing export variables in node '%s'." % [self.name])
	pass

func _physics_process(delta: float) -> void:
	cube_node.rotate(Vector3.ONE.normalized(), 1 * delta)
	pass
