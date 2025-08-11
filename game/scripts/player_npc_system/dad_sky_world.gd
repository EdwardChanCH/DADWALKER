class_name _DadSkyWorld
extends _CharacterWorld

@export var camera: Camera3D = null

func _ready() -> void:
	super._ready()
	
	use_sky_camera()
	use_ground_camera()
	pass

func use_sky_camera() -> void:
	camera.position = Vector3(0, 0, 2)
	camera.rotation_degrees = Vector3(30, 0, 0)
	pass

func use_ground_camera() -> void:
	camera.position = Vector3(0, 2.2, 2)
	camera.rotation_degrees = Vector3(-30, 0, 0)
	pass
