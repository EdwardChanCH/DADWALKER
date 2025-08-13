class_name _MainCamera
extends Camera2D

signal target_reached

@export var gameplay_node: _Gameplay = null

@export var camera_animation: AnimationPlayer = null

@export var map_trigger: Area2D = null

@export var lerp_decay: float = 8

@export var tracking_node: Node2D = null :
	get:
		return tracking_node
	set(value):
		tracking_node = value
		if (value):
			__target_reached_emitted = false
			map_trigger.monitoring = false
			map_trigger.monitorable = false
			x_limit_min = value.global_position.x # Resets x-limit.

var __target_reached_emitted: bool = true

## How far the camera can move left.
var x_limit_min: float = 0

func _ready() -> void:
	# Check if missing export variables.
	if (not gameplay_node
		or not camera_animation):
		push_error("Missing export variables in node '%s'." % [self.name])
	
	map_trigger.monitoring = true
	map_trigger.monitorable = true
	pass


func _physics_process(delta: float) -> void:
	# DO NOT USE _process(), which causes screen jittering.
	
	if tracking_node:
		var current_pos_x: float = self.global_position.x
		
		# Node tracking with x-axis limit.
		var target_pos_x: float = tracking_node.global_position.x
		if (target_pos_x < x_limit_min):
			target_pos_x = x_limit_min
		else:
			x_limit_min = target_pos_x
		
		if (abs(current_pos_x - target_pos_x) < 20):
			# Very close to the target.
			#current_pos_x = target_pos_x # Unnecessary.
			if (not __target_reached_emitted):
				__target_reached_emitted = true
				map_trigger.monitoring = true
				map_trigger.monitorable = true
				target_reached.emit()
		else:
			# Smoothly move the camera to the target.
			current_pos_x = lerpf(
				current_pos_x,
				target_pos_x,
				Globals.lerp_t(lerp_decay, delta)
			)
		
		# Teleports the player if lagging too far behind the camera. (1920/2 + 100)
		if (gameplay_node.player.global_position.x < current_pos_x - 1060):
			gameplay_node.player.global_position.x = current_pos_x - 1060
		elif (gameplay_node.player.global_position.x > current_pos_x + 1060):
			gameplay_node.player.global_position.x = current_pos_x + 1060
		
		# Update camera position.
		self.global_transform.origin.x = current_pos_x
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
