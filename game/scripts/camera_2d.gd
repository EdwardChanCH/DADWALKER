class_name _MainCamera
extends Camera2D

signal target_reached

@export var gameplay_node: _Gameplay = null

@export var camera_animation: AnimationPlayer = null

@export var map_trigger: Area2D = null

@export var tracking_node: Node2D = null :
	get:
		return tracking_node
	set(value):
		__target_reached_emitted = false
		map_trigger.monitoring = false
		map_trigger.monitorable = false
		tracking_node = value

var __target_reached_emitted: bool = true

@export var lerp_decay: float = 10

func _ready() -> void:
	# Check if missing export variables.
	if (not gameplay_node
		or not camera_animation):
		push_error("Missing export variables in node '%s'." % [self.name])
	
	map_trigger.monitoring = true
	map_trigger.monitorable = true
	pass

func _process(delta: float) -> void:
	if tracking_node:
		# Track node position.
		var target_pos: Vector2 = tracking_node.global_position
		
		if (abs(self.global_position.x - target_pos.x) < 20):
			# Abruptly move the camera.
			self.global_position.x = target_pos.x
			if (not __target_reached_emitted):
				__target_reached_emitted = true
				map_trigger.monitoring = true
				map_trigger.monitorable = true
				target_reached.emit()
		else:
			# Smoothly move the camera.
			self.global_position.x = lerpf(
				self.global_position.x,
				target_pos.x,
				Globals.lerp_t(lerp_decay, delta)
			)
			# Teleports the player if lagging too far behind the camera.
			if (gameplay_node.player.global_position.x < self.global_position.x - 1060):
				gameplay_node.player.global_position.x = self.global_position.x - 1060
			elif (gameplay_node.player.global_position.x > self.global_position.x + 1060):
				gameplay_node.player.global_position.x = self.global_position.x + 1060
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
