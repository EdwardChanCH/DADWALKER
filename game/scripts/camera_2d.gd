class_name _MainCamera
extends Camera2D

signal target_reached

@export var gameplay_node: _Gameplay = null

@export var camera_animation: AnimationPlayer = null

@export var tracking_node: Node2D = null

@export var lerp_decay: float = 10

func _ready() -> void:
	# Check if missing export variables.
	if (not gameplay_node
		or not camera_animation):
		push_error("Missing export variables in node '%s'." % [self.name])
	pass

func _process(delta: float) -> void:
	if tracking_node:
		var target_pos: Vector2 = tracking_node.global_position
		
		if (abs(self.global_position.x - target_pos.x) < 20):
			# Abruptly move the camera.
			self.global_position.x = target_pos.x
			target_reached.emit()
		else:
			# Smoothly move the camera.
			self.global_position.x = lerpf(
				self.global_position.x,
				target_pos.x,
				Globals.lerp_t(lerp_decay, delta)
			)
			# Teleports player if lagging too far behind.
			if (gameplay_node.player.global_position.x < self.global_position.x - 100):
				gameplay_node.player.global_position.x = self.global_position.x - 100
	pass

## Shake the camera.
func shake_camera() -> void:
	camera_animation.play("camera_shake")
	pass

## Despawn tomatoes.
func _on_tomato_despawner_body_entered(body: Node2D) -> void:
	if (body is _BasicEnemy):
		body.queue_free()
	pass
