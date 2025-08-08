class_name _Gameplay
extends Node2D

# TODO

@export var game_object_list: Node2D = null

@export var projectile_list: Node2D = null

func _ready() -> void:
	Globals.gameplay = self
	pass

## Add projectie to gameplay scene.
func add_projectie_to_scene(new_projectile: _Projectile) -> void:
	projectile_list.call_deferred("add_child", new_projectile)
	pass
