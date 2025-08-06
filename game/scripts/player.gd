class_name _Player
extends CharacterBody2D

## Dragoon world (handles model animations).
@export var dragoon_world_node: _DragoonWorld = null

## Accept player input or not.
@export var can_control: bool = false

## Player input vector (similar to joystick input).
var input_vector: Vector2 = Vector2.ZERO

## Payer movement speed.
var move_speed: float = 400.0

func _ready() -> void:
	# Check if missing export variables.
	if (not dragoon_world_node):
		push_error("Missing export variables in node '%s'." % [self.name])
	pass

func _physics_process(_delta: float) -> void:
	var direction: Vector2 = input_vector.normalized()
	
	self.velocity = direction * move_speed
	self.move_and_slide()
	
	if (direction != Vector2.ZERO):
		dragoon_world_node.target_look_vector = direction
	pass

func _unhandled_input(event: InputEvent) -> void:
	if (not can_control):
		return
	
	var key := event as InputEventKey
	var mouse_button := event as InputEventMouseButton
	var mouse_motion := event as InputEventMouseMotion
	
	if key:
		if event.is_action_pressed("move_player_in"):
			input_vector += Vector2.UP
		elif event.is_action_pressed("move_player_out"):
			input_vector += Vector2.DOWN
		elif event.is_action_pressed("move_player_left"):
			input_vector += Vector2.LEFT
		elif event.is_action_pressed("move_player_right"):
			input_vector += Vector2.RIGHT
		
		if event.is_action_released("move_player_in"):
			input_vector -= Vector2.UP
		elif event.is_action_released("move_player_out"):
			input_vector -= Vector2.DOWN
		elif event.is_action_released("move_player_left"):
			input_vector -= Vector2.LEFT
		elif event.is_action_released("move_player_right"):
			input_vector -= Vector2.RIGHT
	elif mouse_button:
		pass
	elif mouse_motion:
		pass
	else:
		push_warning("Warning: Unexpected input type: \"%s\"." % [event])
	pass
