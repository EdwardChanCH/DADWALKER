class_name _Dragoon
extends Node3D

@export var animation_player: AnimationPlayer = null

func _ready() -> void:
	# Check if missing export variables.
	if (not animation_player):
		push_error("Missing export variables in node '%s'." % [self.name])
	pass
