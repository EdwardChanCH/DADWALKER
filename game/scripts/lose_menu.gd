class_name _LoseMenu
extends CanvasLayer

signal ui_close
signal ui_open

func _ready() -> void:
	visible = false
	Globals.lose_menu = self
	pass

func _on_visibility_changed() -> void:
	if (!visible):
		ui_close.emit()
		return
	ui_open.emit()
	pass

func _on_mouse_entered() -> void:
	AudioManager.play_sfx("res://assets/sounds/sfx/sfx_ui_cursor_fd1.ogg", 0.5)
	pass

func _on_retry_button_pressed() -> void:
	AudioManager.play_sfx("res://assets/sounds/sfx/sfx_ui_cursor_fd1.ogg", 0.5)
	Globals.gameplay.change_map_to(Globals.progress) # Reload the same level.
	visible = false
	pass

func _on_exit_button_pressed() -> void:
	AudioManager.play_sfx("res://assets/sounds/sfx/sfx_ui_confirm_fd1.ogg", 0.5)
	Globals.gameplay.change_map_to(Globals.Checkpoint.MAINMENU)
	Globals.main_menu.visible = true
	visible = false
	pass

func _on_setting_button_pressed() -> void:
	AudioManager.play_sfx("res://assets/sounds/sfx/sfx_ui_confirm_fd1.ogg", 0.5)
	Globals.setting_menu.visible = true
	pass

func _on_credits_button_pressed() -> void:
	AudioManager.play_sfx("res://assets/sounds/sfx/sfx_ui_confirm_fd1.ogg", 0.5)
	Globals.credit_menu.visible = true
	pass
