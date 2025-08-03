extends Node3D

@export var cube: MeshInstance3D = null

func _physics_process(delta: float) -> void:
	cube.rotate(Vector3.ONE.normalized(), 1 * delta)
	pass
