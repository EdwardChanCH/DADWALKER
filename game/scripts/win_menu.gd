class_name _WinMenu
extends CanvasLayer

signal ui_close
signal ui_open

func _ready() -> void:
	visible = false
	Globals.win_menu = self
	pass

func _on_visibility_changed() -> void:
	if (!visible):
		ui_close.emit()
		return
	
	Globals.change_bgm("res://assets/sounds/bgm/bgm_gameplay_rd2.ogg")
	ui_open.emit()
	pass

func _on_mouse_entered() -> void:
	AudioManager.play_sfx("res://assets/sounds/sfx/sfx_ui_cursor_fd1.ogg", 0.5)
	pass

func _on_to_be_continued_button_pressed() -> void:
	AudioManager.play_sfx("res://assets/sounds/sfx/sfx_ui_confirm_fd1.ogg", 0.5)
	Globals.gameplay.change_map_to(Globals.Checkpoint.ENDING)
	Globals.main_menu.visible = true
	Globals.credit_menu.visible = true
	visible = false
	pass
