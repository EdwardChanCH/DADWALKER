class_name _FirstStreetFight
extends _ScriptedSequence

func enter_cutscene() -> void:
	map_used_before = true
	
	self.visible = true
	
	if (Globals.gameplay):
		Globals.gameplay.main_camera.tracking_node = camera_target
	
	cutscene_finished.emit()
	pass
