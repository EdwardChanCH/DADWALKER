class_name _Dragoon
extends _Character

@export var animation_player: AnimationPlayer = null

func _ready() -> void:
	super._ready()
	
	# Check if missing export variables.
	if (not animation_player):
		push_error("Missing export variables in node '%s'." % [self.name])
	pass

func start_walk() -> void:
	animation_player.play("dragoon_walk")
	pass
