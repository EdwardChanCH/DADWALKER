extends Node
## Use this script to initialize the game.

func _ready() -> void:
	# Start at main menu.
	if (Globals.gameplay and Globals.main_menu):
		Globals.gameplay.change_map_to(_Globals.Checkpoint.MAINMENU)
		Globals.main_menu.visible = true
	else:
		push_error("'Main' node failed to start the game.")
	pass
