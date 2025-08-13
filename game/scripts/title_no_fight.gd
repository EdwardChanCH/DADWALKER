class_name _TitleNoFight
extends _ScriptedSequence

func _ready() -> void:
	super._ready()
	
	# Check if missing export variables.
	if (false):
		push_error("Missing export variables in node '%s'." % [self.name])
	
	self.visible = false
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
