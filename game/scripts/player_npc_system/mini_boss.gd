class_name _MiniBoss
extends _GameObject

func _ready() -> void:
	super._ready()
	
	# Check if missing export variables.
	if (false):
		push_error("Missing export variables in node '%s'." % [self.name])
	
	# TODO
	# Initialize variables.
	in_player_control = false
	move_speed = 400
	max_health = 1
	current_health = 1
	pass
