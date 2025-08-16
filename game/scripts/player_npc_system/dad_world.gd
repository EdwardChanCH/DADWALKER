class_name _DadWorld
extends _CharacterWorld

@export var animation_player: AnimationPlayer = null

func start_rolling() -> void:
	if (animation_player.current_animation != "roll_right"):
		animation_player.stop()
		animation_player.play("roll_right", -1, 2)
	pass

func start_rolling_fast() -> void:
	if (animation_player.current_animation != "roll_right"):
		animation_player.stop()
		animation_player.play("roll_right", -1, 6)
	pass

func stop_rolling() -> void:
	animation_player.pause()
	pass
