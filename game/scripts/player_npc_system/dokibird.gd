class_name _Dokibird
extends _Character

@export var animation_player: AnimationPlayer = null

func _ready() -> void:
	super._ready()
	
	# Check if missing export variables.
	if (not animation_player):
		push_error("Missing export variables in node '%s'." % [self.name])
	pass

func update_health_bar(new_health: int) -> void:
	# TODO
	print("Not implemented yet! (%s)" % ["dokibird:update_health_bar"])
	pass

func start_walk() -> void:
	animation_player.play("dragoon_walk")
	pass
