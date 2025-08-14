class_name _Dad
extends _Character

@export var animation_player: AnimationPlayer = null

func _ready() -> void:
	super._ready()
	
	# Check if missing export variables.
	if (not animation_player):
		push_error("Missing export variables in node '%s'." % [self.name])
	pass

func start_walk() -> void:
	if (animation_player.has_animation("dragoon_walk")):
		animation_player.play("dragoon_walk") # TODO
	pass

func start_t_pose() -> void:
	print("dad: Not implemented yet!")
	pass
