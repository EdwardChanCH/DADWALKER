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
	var menu: PackedScene = load("res://scenes/ui/setting_menu.tscn")
	add_child(menu.instantiate())
	pass


func _on_credits_button_pressed() -> void:
	var menu: PackedScene = load("res://scenes/ui/credit_menu.tscn")
	add_child(menu.instantiate())
	SceneTree
	pass
