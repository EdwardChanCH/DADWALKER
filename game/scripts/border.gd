class_name _Border
extends CanvasLayer

signal ui_close
signal ui_open

signal slide_in_animation_finish
signal slide_out_animation_finish

@export var animation_player: AnimationPlayer

func _ready() -> void:
	visible = false
	Globals.border_ui = self
	pass

func play_slide_in_animation() -> Signal:
	animation_player.play("slide_in")
	slide_in_animation_finish.emit()
	return animation_player.animation_finished

func play_slide_out_animation() -> Signal:
	animation_player.play("slide_out")
	slide_out_animation_finish.emit()
	return animation_player.animation_finished

func _on_visibility_changed() -> void:
	if (!visible):
		play_slide_out_animation()
		ui_close.emit()
		return
	
	play_slide_in_animation()
	ui_open.emit()
	pass
