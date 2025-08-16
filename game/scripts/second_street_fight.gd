class_name _SecondStreetFight
extends _ScriptedSequence

@export var spawner_group_1: Array[_EnemySpawner] = []
@export var spawner_group_2: Array[_EnemySpawner] = []
@export var spawner_group_3: Array[_EnemySpawner] = []

func exit_cutscene() -> void:
	if (Globals.gameplay):
		Globals.gameplay.queue_free_all_projectiles()
		Globals.gameplay.queue_free_all_game_objects()
		Globals.gameplay.main_camera.tracking_node = Globals.gameplay.player
	
	cutscene_finished.emit()
	pass

func enter_cutscene(_mode: int = 0) -> void:
	map_used_before = true
	Globals.progress = Globals.Checkpoint.MINI_BOSS_END
	Globals.change_bgm("res://assets/sounds/bgm/bgm_gameplay_rd2.ogg")
	
	self.visible = true
	
	if (Globals.gameplay):
		Globals.gameplay.player.restore_health()
		Globals.gameplay.main_camera.tracking_node = camera_target
		await Globals.gameplay.main_camera.target_reached
	
	exit_cutscene()
	pass

func _on_enemy_trigger_1_camera_in_range() -> void:
	for spawner in spawner_group_1:
		spawner.spawn_object()
	pass

func _on_enemy_trigger_2_camera_in_range() -> void:
	for spawner in spawner_group_2:
		spawner.spawn_object()
	pass

func _on_enemy_trigger_3_camera_in_range() -> void:
	for spawner in spawner_group_3:
		spawner.spawn_object()
	pass
