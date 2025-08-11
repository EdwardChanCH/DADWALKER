extends Node2D

@export var game_object_scene: PackedScene = null

@export var auto_spawn_timer: Timer = null

func _ready() -> void:
	if (auto_spawn_timer):
		auto_spawn_timer.timeout.connect(_on_auto_spawn_timer_timeout)
	pass

func spawn_object() -> void:
	if not game_object_scene:
		return
	
	var game_object: _GameObject = game_object_scene.instantiate()
	if not game_object:
		return
	
	if (Globals.gameplay):
		Globals.gameplay.add_game_object_to_scene(game_object)
	
	game_object.global_transform.origin = self.global_position
	game_object.reset_physics_interpolation()
	game_object.idle_vector = Vector2.LEFT.rotated(self.rotation)
	pass

func _on_auto_spawn_timer_timeout() -> void:
	spawn_object()
	
	if (auto_spawn_timer):
		auto_spawn_timer.start()
	pass
