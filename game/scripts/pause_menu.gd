class_name _PauseMenu
extends CanvasLayer

signal ui_close
signal ui_open

func _ready() -> void:
	visible = false
	Globals.pause_menu = self
	pass

func _on_visibility_changed() -> void:
	if (is_inside_tree()):
		get_tree().paused = visible
	
	if (visible):
		ui_open.emit()
	else:
		ui_close.emit()
	pass

func _on_mouse_entered() -> void:
	AudioManager.play_sfx("res://assets/sounds/sfx/sfx_ui_cursor_fd1.ogg", 0.5)
	pass

func _on_close_button_pressed() -> void:
	AudioManager.play_sfx("res://assets/sounds/sfx/sfx_ui_back_fd1.ogg", 0.5)
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
