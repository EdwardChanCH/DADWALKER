class_name _MainMenu
extends CanvasLayer

@export var animation_player: AnimationPlayer = null

@export var buttons: Array[TextureButton] = []

func _ready() -> void:
	# Check if missing export variables.
	if (not animation_player):
		push_error("Missing export variables in node '%s'." % [self.name])
	pass

func _on_play_button_pressed() -> void:
	# Disable all buttons.
	for button in buttons:
		button.disabled = true
	
	# Play exit main menu animation.
	animation_player.play("close_popup")
	pass


func _on_options_button_pressed() -> void:
	var menu: PackedScene = load(Globals.SETTING_MENU_PATH)
	add_child(menu.instantiate())
	pass


func _on_credits_button_pressed() -> void:
	var menu: PackedScene = load(Globals.CREDIT_MENU_PATH)
	add_child(menu.instantiate())
	pass
