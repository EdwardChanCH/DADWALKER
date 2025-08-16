class_name _DadSkyWorld
extends _CharacterWorld

@export var camera: Camera3D = null

func _ready() -> void:
	character_node.start_t_pose()
	pass

func use_sky_camera() -> void:
	camera.position = Vector3(0.0, 0.1, 2.0)
	camera.rotation_degrees = Vector3(20, 0, 0)
	pass

func use_ground_camera() -> void:
	camera.position = Vector3(0.0, 2.1, 2.0)
	camera.rotation_degrees = Vector3(-30, 0, 0)
	pass
