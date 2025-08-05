class_name _Player
extends CharacterBody2D

var input_direction: Vector2 = Vector2.ZERO
var move_speed: float = 400.0

func _physics_process(_delta: float) -> void:
	var direction = input_direction.normalized()
	self.velocity = direction * move_speed
	self.move_and_slide()
	pass

func _unhandled_input(event: InputEvent) -> void:
	var key := event as InputEventKey
	var mouse_button := event as InputEventMouseButton
	var mouse_motion := event as InputEventMouseMotion
	
	if key:
		if event.is_action_pressed("move_player_in"):
			input_direction += Vector2.UP
		elif event.is_action_pressed("move_player_out"):
			input_direction += Vector2.DOWN
		elif event.is_action_pressed("move_player_left"):
			input_direction += Vector2.LEFT
		elif event.is_action_pressed("move_player_right"):
			input_direction += Vector2.RIGHT
		
		if event.is_action_released("move_player_in"):
			input_direction -= Vector2.UP
		elif event.is_action_released("move_player_out"):
			input_direction -= Vector2.DOWN
		elif event.is_action_released("move_player_left"):
			input_direction -= Vector2.LEFT
		elif event.is_action_released("move_player_right"):
			input_direction -= Vector2.RIGHT
	elif mouse_button:
		pass
	elif mouse_motion:
		pass
	else:
		push_warning("Warning: Unexpected input type: \"%s\"." % [event])
	pass
