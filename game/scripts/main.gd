extends Node
## Use this script to initialize the game.

func _ready() -> void:
	var object1: _NPC = _NPC.new()
	var object2: _NPC = _Player.new()
	var object3: _Player = _Player.new()
	
	object1.test() # A from _NPC.test()
	object2.test() # B from _Player.test()
	object3.test() # B from _Player.test()
	
	# Conclusion:
	# GDScript uses method overriding instead of method hiding.
	# https://stackoverflow.com/a/3838692
	pass
