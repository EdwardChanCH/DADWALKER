class_name _FirstStreetFight
extends _ScriptedSequence

func exit_cutscene() -> void:
	if (Globals.gameplay):
		Globals.gameplay.main_camera.tracking_node = Globals.gameplay.player
	
	cutscene_finished.emit()
	pass

func enter_cutscene() -> void:
	map_used_before = true
	
	self.visible = true
	
	exit_cutscene()
	pass
