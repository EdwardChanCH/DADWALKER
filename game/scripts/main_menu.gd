class_name _MainMenu
extends CanvasLayer

signal ui_close
signal ui_open

@export var animation_player: AnimationPlayer = null
@export var buttons: Array[TextureButton] = []

func _ready() -> void:
	# Check if missing export variables.
	if (not animation_player):
		push_error("Missing export variables in node '%s'." % [self.name])
		
	Globals.main_menu = self
	pass

func _on_play_button_pressed() -> void:
	# Disable all buttons.
	for button in buttons:
		button.disabled = true
	
	# Play exit main menu animation.
	animation_player.play("close_popup")
	AudioManager.play_sfx("res://assets/sounds/sfx/sfx_ui_confirm_fd1.ogg")
	
	# Wait for animate to finish before emiting the close signal
	await animation_player.animation_finished
	visible = false
	pass

func _on_options_button_pressed() -> void:
	AudioManager.play_sfx("res://assets/sounds/sfx/sfx_ui_confirm_fd1.ogg", 0.5)
	Globals.setting_menu.visible = true
	pass

func _on_credits_button_pressed() -> void:
	AudioManager.play_sfx("res://assets/sounds/sfx/sfx_ui_confirm_fd1.ogg", 0.5)
	Globals.credit_menu.visible = true
	pass

func _on_mouse_entered() -> void:
	AudioManager.play_sfx("res://assets/sounds/sfx/sfx_ui_cursor_fd1.ogg", 0.5)
	pass
	
func _on_visibility_changed() -> void:
	if (!visible):
		ui_close.emit()
		return
	ui_open.emit()
	pass
