class_name _DragoonWorld
extends Node3D

@export var dragoon_node: _Dragoon = null

var animation_node: AnimationPlayer = null

func _ready() -> void:
	# Check if missing export variables.
	if (not dragoon_node):
		push_error("Missing export variables in node '%s'." % [self.name])
	
	animation_node = dragoon_node.animation_player
	
	# TODO test only
	animation_node.play("dragoon_walk")
	pass
