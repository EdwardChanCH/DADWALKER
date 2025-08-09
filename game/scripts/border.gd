class_name _Border
extends Node

signal slide_in_animation_finish
signal slide_out_animation_finish

@export var animation_player: AnimationPlayer

func play_slide_in_animation() -> Signal:
	animation_player.play("slide_in")
	slide_in_animation_finish.emit()
	return animation_player.animation_finished

func play_slide_out_animation() -> Signal:
	animation_player.play_backwards("slide_in")
	slide_out_animation_finish.emit()
	return animation_player.animation_finished
