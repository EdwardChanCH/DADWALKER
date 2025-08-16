class_name _DokibirdWorld
extends _CharacterWorld

@export var animation_player: AnimationPlayer = null

func start_handsup() -> void:
	character_node.start_handsup()
	pass

func start_backflip(_reversed: bool) -> void:
	character_node.start_handsup()
	if (_reversed):
		animation_player.play_backwards("roll_forward")
	else:
		animation_player.play("roll_forward")
	pass
