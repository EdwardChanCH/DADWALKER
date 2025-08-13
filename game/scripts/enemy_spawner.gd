class_name _EnemySpawner
extends Node2D

@export var game_object_scene: PackedScene = null

@export var auto_spawn_timer: Timer = null

## (not normalized)
@export var direction: Vector2 = Vector2.LEFT

@export var target_node: Node2D = null

@export var push_velocity: Vector2 = Vector2.ZERO

func _ready() -> void:
	if (auto_spawn_timer):
		auto_spawn_timer.timeout.connect(_on_auto_spawn_timer_timeout)
		auto_spawn_timer.paused = true
	pass

func start_spawning() -> void:
	if (auto_spawn_timer):
		auto_spawn_timer.paused = false
		auto_spawn_timer.start()
	else:
		spawn_object()
	pass

func stop_spawning() -> void:
	if (auto_spawn_timer):
		auto_spawn_timer.paused = true
		auto_spawn_timer.stop()
	pass

func spawn_object() -> _GameObject:
	if not game_object_scene:
		return
	
	var game_object: _GameObject = game_object_scene.instantiate()
	if not game_object:
		return
	
	if (Globals.gameplay):
		Globals.gameplay.add_game_object_to_scene(game_object)
	
	game_object.global_transform.origin = self.global_position
	game_object.reset_physics_interpolation()
	game_object.idle_vector = direction
	game_object.tracking_object = target_node
	game_object.push_velocity = push_velocity
	
	return game_object

func _on_auto_spawn_timer_timeout() -> void:
	spawn_object()
	
	if (auto_spawn_timer):
		auto_spawn_timer.start()
	pass
