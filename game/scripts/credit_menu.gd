class_name _CreditMenu
extends CanvasLayer

signal ui_close
signal ui_open

@export var close_button_animation_tree: AnimationTree
@export var animation_player: AnimationPlayer

func _ready() -> void:
	visible = false
	Globals.credit_menu = self
	pass


func _on_mouse_entered() -> void:
	AudioManager.play_sfx("res://assets/sounds/sfx/sfx_ui_cursor_fd1.ogg", 0.5)
	pass


func _on_close_button_pressed() -> void:
	AudioManager.play_sfx("res://assets/sounds/sfx/sfx_ui_back_fd1.ogg", 0.5)
	animation_player.play("slide_out")
	await animation_player.animation_finished
	visible = false
	pass


func _on_close_button_mouse_entered() -> void:
	close_button_animation_tree.set("parameters/Rotation/transition_request", "Hover") 
	pass 


func _on_close_button_mouse_exited() -> void:
	close_button_animation_tree.set("parameters/Rotation/transition_request", "Idle") 
	pass


func _on_visibility_changed() -> void:
	if (visible):
		animation_player.play("slide_in")
		ui_open.emit()
		return
		
	ui_close.emit()
	pass
