class_name _MainCamera
extends Camera2D

signal target_reached

@export var gameplay_node: _Gameplay = null

@export var camera_animation: AnimationPlayer = null

@export var level_trigger: Area2D = null

@export var lerp_decay: float = 8

@export var tracking_node: Node2D = null :
	get:
		return tracking_node
	set(value):
		tracking_node = value
		if (value):
			__target_reached_emitted = false
			level_trigger.set_deferred("monitoring", false)
			level_trigger.set_deferred("monitorable", false)
			if not(value is _Player):
				x_limit_min = value.global_position.x # Resets x-limit.

var __target_reached_emitted: bool = true

## How far the camera can move left.
var x_limit_min: float = 0

func _ready() -> void:
	# Check if missing export variables.
	if (not gameplay_node
		or not camera_animation):
		push_error("Missing export variables in node '%s'." % [self.name])
	
	__target_reached_emitted = true
	level_trigger.set_deferred("monitoring", true)
	level_trigger.set_deferred("monitorable", true)
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
		
		# Fix missed detection if Player is moving when a boss fight ends.
		if (tracking_node is _Player):
			if (not __target_reached_emitted):
				__target_reached_emitted = true
				level_trigger.set_deferred("monitoring", true)
				level_trigger.set_deferred("monitorable", true)
				target_reached.emit()
				print("Camera emitted 'target_reached'.") # TODO
		
		# Checks if the camera is close enough to the target.
		if (abs(current_pos_x - target_pos_x) < 1):
			# Very close to the target.
			#current_pos_x = target_pos_x # Unnecessary.
			if (not __target_reached_emitted):
				__target_reached_emitted = true
				level_trigger.set_deferred("monitoring", true)
				level_trigger.set_deferred("monitorable", true)
				target_reached.emit()
				print("Camera emitted 'target_reached'.") # TODO
		
		# Smoothly move the camera to the target.
		current_pos_x = lerpf(
			current_pos_x,
			target_pos_x,
			Globals.lerp_t(lerp_decay, delta)
		)
		
		# Teleports the player if lagging too far behind the camera. (1920/2)
		if (gameplay_node.player.global_position.x < current_pos_x - 960):
			gameplay_node.player.global_position.x = current_pos_x - 960
		elif (gameplay_node.player.global_position.x > current_pos_x + 960):
			gameplay_node.player.global_position.x = current_pos_x + 960
		
		# Update camera position.
		self.global_transform.origin.x = current_pos_x
	pass

## Shake the camera.
func shake_camera() -> void:
	camera_animation.play("camera_shake")
	pass
