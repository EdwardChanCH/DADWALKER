class_name _PauseMenu
extends CanvasLayer

func _ready() -> void:
	visible = false
	Globals.pause_menu = self
	pass
