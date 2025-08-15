class_name _LoseMenu
extends CanvasLayer

signal ui_close
signal ui_open

func _ready() -> void:
	visible = false
	Globals.lose_menu = self
	pass

func _on_retry_button_pressed() -> void:
	visible = false
	pass

func _on_menu_button_pressed() -> void:
	visible = false
	pass

func _on_visibility_changed() -> void:
	if (!visible):
		ui_close.emit()
		return
	ui_open.emit()
	pass
