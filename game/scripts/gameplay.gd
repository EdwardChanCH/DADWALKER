class_name _Gameplay
extends Node2D

@export var main_camera: _MainCamera = null

@export var game_object_list: Node2D = null

@export var projectile_list: Node2D = null

func _ready() -> void:
	# Check if missing export variables.
	if (not main_camera
		or not game_object_list
		or not projectile_list):
		push_error("Missing export variables in node '%s'." % [self.name])
	
	Globals.gameplay = self
	pass

## Add projectie to gameplay scene.
func add_projectie_to_scene(new_projectile: _Projectile) -> void:
	projectile_list.call_deferred("add_child", new_projectile)
	pass

## Add game object to gameplay scene.
func add_game_object_to_scene(new_game_object: _GameObject) -> void:
	game_object_list.call_deferred("add_child", new_game_object)
	pass
