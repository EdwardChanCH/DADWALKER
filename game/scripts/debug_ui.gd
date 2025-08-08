class_name _DebugUI
extends Control

@export var fps_node : Label = null

func _ready() -> void:
	# Check if missing export variables.
	if (not fps_node):
		push_error("Missing export variables in node '%s'." % [self.name])
	pass

func _process(_delta: float) -> void:
	# Check if running in editor.
	if not Engine.is_editor_hint():
		fps_node.text = "%.0f FPS" % [Engine.get_frames_per_second()]
