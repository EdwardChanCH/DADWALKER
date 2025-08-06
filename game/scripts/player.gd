class_name _Player
extends _NPC

## Dragoon world (handles model animations).
@export var dragoon_world_node: _DragoonWorld = null

## Accept player input or not.
@export var can_control: bool = false

## Player input vector (not normalized).
var input_vector: Vector2 = Vector2.ZERO

## Null-cancelling vector (not normalized).
var null_cancelling_vector: Vector2 = Vector2.ZERO

## Payer movement speed.
var move_speed: float = 400.0

func test() -> void:
	print("B")
	pass

func _ready() -> void:
	super._ready() # Reuse super-class's method.
	
	# Check if missing export variables.
	if (not dragoon_world_node):
		push_error("Missing export variables in node '%s'." % [self.name])
	pass

func _process(delta: float) -> void:
	super._process(delta) # Reuse super-class's method.
	
	# --- Detect Player Input --- #
	# Uses null-cancelling movement (like in Team Fortress 2)
	
	if (Input.is_action_pressed("move_player_left")
		and Input.is_action_pressed("move_player_right")):
		input_vector.x = null_cancelling_vector.x
	elif Input.is_action_pressed("move_player_left"):
		input_vector.x = -1
		null_cancelling_vector.x = 1
	elif Input.is_action_pressed("move_player_right"):
		input_vector.x = 1
		null_cancelling_vector.x = -1
	else:
		input_vector.x = 0
	
	if (Input.is_action_pressed("move_player_in")
		and Input.is_action_pressed("move_player_out")):
		input_vector.y = null_cancelling_vector.y
	elif Input.is_action_pressed("move_player_in"):
		input_vector.y = -1
		null_cancelling_vector.y = 1
	elif Input.is_action_pressed("move_player_out"):
		input_vector.y = 1
		null_cancelling_vector.y = -1
	else:
		input_vector.y = 0
	
	pass

func _physics_process(_delta: float) -> void:
	var direction: Vector2 = input_vector.normalized()
	
	self.velocity = direction * move_speed
	self.move_and_slide()
	
	if (direction != Vector2.ZERO):
		dragoon_world_node.target_look_vector = direction
	pass
