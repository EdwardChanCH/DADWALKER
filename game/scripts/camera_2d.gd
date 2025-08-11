class_name _MainCamera
extends Camera2D

@export var camera_animation: AnimationPlayer = null

@export var tracking_node: Node2D = null

@export var lerp_decay: float = 10

func _ready() -> void:
	# Check if missing export variables.
	if (not camera_animation):
		push_error("Missing export variables in node '%s'." % [self.name])
	
	Globals.camera = self
	pass

func _process(delta: float) -> void:
	if tracking_node:
		var target_pos: Vector2 = tracking_node.global_position
		if (abs(self.global_position.x - target_pos.x) < 20):
			self.global_position.x = target_pos.x
		else:
			self.global_position.x = lerpf(
				self.global_position.x,
				target_pos.x,
				Globals.lerp_t(lerp_decay, delta)
			)
	pass

## Shake the camera.
func shake_camera() -> void:
	camera_animation.play("camera_shake")
	pass
