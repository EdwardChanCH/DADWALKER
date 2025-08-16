class_name _Dad
extends _Character

@export var animation_player: AnimationPlayer = null

func _ready() -> void:
	super._ready()
	
	# Check if missing export variables.
	if (not animation_player):
		push_error("Missing export variables in node '%s'." % [self.name])
	pass

func start_idle() -> void:
	animation_player.stop()
	animation_player.play("dad_iddle")
	pass

func start_t_pose() -> void:
	animation_player.stop()
	animation_player.play("dad_tpose")
	pass
