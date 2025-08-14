class_name _SecondStreetFight
extends _ScriptedSequence

func exit_cutscene() -> void:
	if (Globals.gameplay):
		Globals.gameplay.main_camera.tracking_node = Globals.gameplay.player
	
	cutscene_finished.emit()
	pass

func enter_cutscene(_mode: int = 0) -> void:
	map_used_before = true
	
	self.visible = true
	
	if (Globals.gameplay):
		Globals.gameplay.main_camera.tracking_node = camera_target
		await Globals.gameplay.main_camera.target_reached
	
	exit_cutscene()
	pass
