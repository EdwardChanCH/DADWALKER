class_name _MainMenu
extends CanvasLayer

signal ui_close
signal ui_open

@export var animation_player: AnimationPlayer = null
@export var buttons: Array[TextureButton] = []
@export var audio_tester: CanvasLayer = null

var counter: int = 0
var __ignore_signals: bool = false

func _ready() -> void:
	# Check if missing export variables.
	if (not animation_player):
		push_error("Missing export variables in node '%s'." % [self.name])
		
	Globals.main_menu = self
	
	# Always loaded first.
	visible = true
	pass

func _on_ui_open() -> void:
	# Enable all buttons.
	for button in buttons:
		button.disabled = false
	
	__ignore_signals = false # Stop signal callbacks.
	
	if (Globals.dialogue_ui):
		Globals.dialogue_ui.visible = false
	
	animation_player.play("RESET")
	pass

func _on_play_button_pressed() -> void:
	# Disable all buttons.
	for button in buttons:
		button.disabled = true
	__ignore_signals = true # Stop signal callbacks.
	
	# Play exit main menu animation.
	animation_player.play("close_popup")
	AudioManager.play_sfx("res://assets/sounds/sfx/sfx_ui_confirm_fd1.ogg", 0.5)
	# Note: It is impossible to disable the animation tree,
	#       with the way that the signals are currently connected.
	
	# Wait for animate to finish before emiting the close signal
	await animation_player.animation_finished
	visible = false
	
	# Load intro level.
	Globals.progress = Globals.Checkpoint.INTRO_START
	Globals.gameplay.change_map_to(Globals.Checkpoint.INTRO_START)
	pass

func _on_options_button_pressed() -> void:
	if (__ignore_signals):
		return
	
	AudioManager.play_sfx("res://assets/sounds/sfx/sfx_ui_confirm_fd1.ogg", 0.5)
	Globals.setting_menu.visible = true
	pass

func _on_credits_button_pressed() -> void:
	if (__ignore_signals):
		return
	
	AudioManager.play_sfx("res://assets/sounds/sfx/sfx_ui_confirm_fd1.ogg", 0.5)
	Globals.credit_menu.visible = true
	pass

func _on_mouse_entered() -> void:
	if (__ignore_signals):
		return
	
	AudioManager.play_sfx("res://assets/sounds/sfx/sfx_ui_cursor_fd1.ogg", 0.5)
	pass
	
func _on_visibility_changed() -> void:
	if (!visible):
		ui_close.emit()
		return
	ui_open.emit()
	pass

func _on_rich_text_label_gui_input(event: InputEvent) -> void:
	if (event is InputEventMouseButton):
		counter += 1 # Also counts mouse release, scroll wheel, etc.
	
	if (counter >= 42):
		#var tester: PackedScene = load("res://scenes/ui/test_audio.tscn") as PackedScene
		#add_sibling(tester.instantiate())
		audio_tester.show()
		
		counter = 0
	pass
