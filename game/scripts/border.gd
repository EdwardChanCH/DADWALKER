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

func slide_in() -> void:
	visible = true
	animation_player.play("slide_in")
	await animation_player.animation_finished
	slide_in_animation_finish.emit()
	pass

func slide_out() -> void:
	animation_player.play("slide_out")
	await animation_player.animation_finished
	visible = false
	slide_out_animation_finish.emit()
	pass

func _on_visibility_changed() -> void:
	#push_warning("Do not edit the visibility of the border directly!")
	if (!visible):
		ui_close.emit()
		return
	ui_open.emit()
	pass
