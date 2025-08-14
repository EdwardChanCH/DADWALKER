class_name _PauseMenu
extends CanvasLayer

signal ui_close
signal ui_open

func _ready() -> void:
	visible = false
	Globals.pause_menu = self
	pass



func _on_close_button_pressed() -> void:
	visible = false
	pass # Replace with function body.

func _on_visibility_changed() -> void:
	if (visible):
		get_tree().paused = true
		ui_open
		return
	ui_close.emit()
	
	if(is_inside_tree()):
		get_tree().paused = false
		
	pass # Replace with function body.


func _on_play_button_pressed() -> void:
	
	pass # Replace with function body.


func _on_setting_button_pressed() -> void:
	AudioManager.play_sfx("res://assets/sounds/sfx/sfx_ui_confirm_fd1.ogg", 0.5)
	Globals.setting_menu.visible = true
	pass # Replace with function body.


func _on_credits_button_pressed() -> void:
	AudioManager.play_sfx("res://assets/sounds/sfx/sfx_ui_confirm_fd1.ogg", 0.5)
	Globals.credit_menu.visible = true
	pass # Replace with function body.
