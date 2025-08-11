class_name _PauseMenu
extends CanvasLayer

func _ready() -> void:
	visible = false
	Globals.pause = self
	pass
