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
		Globals.gameplay.main_camera.tracking_node = Globals.gameplay.player
	
	cutscene_finished.emit()
	pass

func enter_cutscene() -> void:
	map_used_before = true
	
	self.visible = true
	
	if (Globals.gameplay):
		Globals.gameplay.main_camera.tracking_node = camera_target
	
	cutscene_finished.emit()
	
	#if (Globals.gameplay):
	#	Globals.gameplay.main_camera.tracking_node = Globals.gameplay.player
	pass

# TODO test only, please remove the area2d when play button is implemented.
func _on_end_of_level_trigger_area_entered(area: Area2D) -> void:
	print("1 End Of Level: TitleNoFight")
	pass

func _on_end_of_level_trigger_area_exited(area: Area2D) -> void:
	print("2 End Of Level: TitleNoFight")
	pass # Replace with function body.
