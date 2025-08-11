extends Node2D

func _ready() -> void:
	# Doesnt really matter since this is just for testing
	$DialogueUI.start_dialgoue(load("res://resources/test_dialogue.tres") as _Dialogue)
	pass
