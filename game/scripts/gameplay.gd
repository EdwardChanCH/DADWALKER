class_name _Gameplay
extends Node2D

# --- Always Loaded --- #
@export var player: _Player = null # Never queue_free.
@export var main_camera: _MainCamera = null # Never queue_free.
@export var game_object_list: Node2D = null # Never queue_free; can free its childrens.
@export var projectile_list: Node2D = null # Never queue_free; can free its childrens.
@export var map_list: Node2D = null # Never queue_free; can free its childrens.

# --- Map Sections --- #
enum Maps {
	TITLE_NO_FIGHT,
	INTRO_NO_FIGHT,
	FIRST_STREET_FIGHT,
	MINI_BOSS_FIGHT,
	SECOND_STREET_FIGHT,
	FINAL_BOSS_FIGHT,
	MAX_VALUE,
}
@export var map_nodes: Array[_ScriptedSequence] = []
@export var map_scenes: Array[PackedScene] = []
@export var map_origins: Array[Vector2] = [] # Initialize this with zero

func _ready() -> void:
	# Check if missing export variables.
	if (not main_camera
		or not game_object_list
		or not projectile_list):
		push_error("Missing export variables in node '%s'." % [self.name])
	
	# Remember map section origins.
	for i in range(0, map_nodes.size(), 1):
		map_origins[i] = map_nodes[i].global_position
	
	# Accessible from Globals to avoid awkward node paths.
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

## Change the camera target and activate a scripted sequence.
## Automatically reloads if map section is null or is used before.
func change_map_to(checkpoint: Globals.Checkpoint) -> void:
	var map_id: Maps = Maps.TITLE_NO_FIGHT
	var before_cutscene: bool = false
	var before_fight: bool = false
	var show_credits: bool = false
	
	# Conversion.
	match (checkpoint):
		Globals.Checkpoint.MAINMENU:
			map_id = Maps.TITLE_NO_FIGHT
			before_cutscene = true
			pass
		Globals.Checkpoint.INTRO_START:
			map_id = Maps.INTRO_NO_FIGHT
			before_cutscene = true
			pass
		Globals.Checkpoint.INTRO_END:
			map_id = Maps.FIRST_STREET_FIGHT
			before_cutscene = true
			pass
		Globals.Checkpoint.MINI_BOSS_START:
			map_id = Maps.MINI_BOSS_FIGHT
			before_cutscene = true
			pass
		Globals.Checkpoint.MINI_BOSS_FIGHT:
			map_id = Maps.MINI_BOSS_FIGHT
			before_fight = true
			pass
		Globals.Checkpoint.MINI_BOSS_END:
			map_id = Maps.SECOND_STREET_FIGHT
			before_cutscene = true
			pass
		Globals.Checkpoint.FINAL_BOSS_START:
			map_id = Maps.FINAL_BOSS_FIGHT
			before_cutscene = true
			pass
		Globals.Checkpoint.FINAL_BOSS_FIGHT:
			map_id = Maps.FINAL_BOSS_FIGHT
			before_fight = true
			pass
		Globals.Checkpoint.FINAL_BOSS_END:
			map_id = Maps.TITLE_NO_FIGHT
			before_cutscene = true
			show_credits = true
			pass
		Globals.Checkpoint.ENDING:
			map_id = Maps.TITLE_NO_FIGHT
			before_cutscene = true
			show_credits = true
			pass
		_:
			map_id = Maps.TITLE_NO_FIGHT
			before_cutscene = true
			pass
		
	# Activate the scripted sequence.
	if (not map_nodes[map_id]):
		reload_map_section(map_id)
	elif (map_nodes[map_id].map_used_before):
		reload_map_section(map_id)
	
	var scripted_sequence: _ScriptedSequence = map_nodes[map_id]
	if (before_fight):
		scripted_sequence.start_fight()
	elif (before_cutscene):
		scripted_sequence.enter_cutscene()
	
	if (show_credits):
		#show_credits() # TODO Bee: open the credits menu.
		pass
	pass

## Queue free and instantiate a new map section instance.
func reload_map_section(map_id: Maps) -> void:
	if (map_id >= Maps.MAX_VALUE):
		push_error("Cannot reload a non-existing map section.")
		return
	
	# TODO not sure if this will crash if animations are playing.
	if (map_nodes[map_id]):
		map_nodes[map_id].queue_free()
	
	map_nodes[map_id] = map_scenes[map_id].instantiate() as _ScriptedSequence
	
	map_nodes[map_id].global_transform.origin = map_origins[map_id]
	self.reset_physics_interpolation()
	pass

## Despawn tomatoes.
func _on_tomato_despawner_body_entered(body: Node2D) -> void:
	if (body is _BasicEnemy):
		body.queue_free()
	pass


func _on_level_trigger_area_entered(area: Area2D) -> void:
	print("test 1")
	pass # Replace with function body.
