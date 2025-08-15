extends Node
## Use this script to initialize the game.

func _unhandled_input(event: InputEvent) -> void:
	if (event.is_action_pressed("pause_game")):
		if (Globals.pause_menu
			and Globals.main_menu and not Globals.main_menu.visible
			and Globals.win_menu and not Globals.win_menu.visible
			and Globals.lose_menu and not Globals.lose_menu.visible):
			# Open the pause menu.
			Globals.pause_menu.visible = not Globals.pause_menu.visible
	pass
