class_name _TitleNoFight
extends _ScriptedSequence

func _ready() -> void:
	super._ready()
	
	# Check if missing export variables.
	if (false):
		push_error("Missing export variables in node '%s'." % [self.name])
	
	self.visible = true # TODO
	pass

func exit_cutscene() -> void:
	if (Globals.gameplay):
		Globals.gameplay.queue_free_all_projectiles()
		Globals.gameplay.queue_free_all_game_objects()
		#Globals.gameplay.main_camera.tracking_node = Globals.gameplay.player
	
	cutscene_finished.emit()
	pass

func enter_cutscene(_mode: int = 0) -> void:
	map_used_before = true
	Globals.progress = Globals.Checkpoint.MAINMENU
	Globals.change_bgm("res://assets/sounds/bgm/bgm_gameplay_rd2.ogg")
	
	self.visible = true
	
	if (Globals.main_menu and (not Globals.main_menu.visible)):
		Globals.main_menu.visible = true # Fail safe.
	
	if (Globals.gameplay):
		Globals.gameplay.player.restore_health()
		Globals.gameplay.main_camera.tracking_node = camera_target
		await Globals.gameplay.main_camera.target_reached
	
	exit_cutscene()
	
	#if (Globals.gameplay):
	#	Globals.gameplay.main_camera.tracking_node = Globals.gameplay.player
	pass
