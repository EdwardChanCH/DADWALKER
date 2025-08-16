class_name _Dragoon
extends _Character

@export var animation_player: AnimationPlayer = null

func _ready() -> void:
	super._ready()
	
	# Check if missing export variables.
	if (not animation_player):
		push_error("Missing export variables in node '%s'." % [self.name])
	pass

func update_health(new_health: int) -> void:
	if (new_health <= 1):
		self.scale = Vector3(0.1, 0.1, 0.1)
	elif (new_health == 2):
		self.scale = Vector3(0.3, 0.3, 0.3)
	elif (new_health >= 3):
		self.scale = Vector3(0.5, 0.5, 0.5)
	pass

func start_walk() -> void:
	animation_player.play("dragoon_walk")
	pass

func start_idle() -> void:
	animation_player.play("dragoon_iddle")
	pass
