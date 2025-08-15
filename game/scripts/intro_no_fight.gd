class_name _IntroNoFight
extends _ScriptedSequence

signal intro_dialogue_started
signal intro_dialogue_ended

func _ready() -> void:
	super._ready()
	
	# Check if missing export variables.
	if (false):
		push_error("Missing export variables in node '%s'." % [self.name])
	
	self.visible = false
	pass

func exit_cutscene() -> void:
	if (Globals.gameplay):
		Globals.gameplay.queue_free_all_projectiles()
		Globals.gameplay.queue_free_all_game_objects()
		Globals.gameplay.main_camera.tracking_node = Globals.gameplay.player
	
	cutscene_finished.emit()
	pass

func enter_cutscene(_mode: int = 0) -> void:
	map_used_before = true
	
	self.visible = true
	
	if (Globals.gameplay):
		Globals.gameplay.player.restore_health()
		Globals.gameplay.main_camera.tracking_node = camera_target
		await Globals.gameplay.main_camera.target_reached
	
	start_dialogue()
	pass

func start_dialogue() -> void:
	map_used_before = true
	
	intro_dialogue_started.emit()
	print("iof: start_dialogue") # TODO
	
	Globals.border_ui.slide_in()
	await Globals.border_ui.slide_in_animation_finish
	
	Globals.dialogue_ui.start_dialgoue(Globals.dialogue_ui.dialogue_1)
	await Globals.dialogue_ui.finish_dialogue
	end_dialogue() # TODO
	pass

func end_dialogue() -> void:
	map_used_before = true
	
	Globals.border_ui.slide_out()
	await Globals.border_ui.slide_out_animation_finish
	
	intro_dialogue_ended.emit()
	print("iof: end_dialogue") # TODO
	
	#start_fight() # Does not have fight.
	exit_cutscene()
	pass
