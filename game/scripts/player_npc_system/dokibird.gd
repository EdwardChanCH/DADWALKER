class_name _Dokibird
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
	animation_player.play("standing pose")
	pass

func start_handsup() -> void:
	animation_player.stop()
	animation_player.play("handsup")
	pass

func start_bullet() -> void:
	animation_player.stop()
	animation_player.play("trow seed", -1, 0.5)
	pass

func start_tomato() -> void:
	animation_player.stop()
	animation_player.play("trow tomato", -1, 0.5)
	pass
