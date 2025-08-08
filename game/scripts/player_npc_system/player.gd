class_name _Player
extends _GameObject

## Keyboard/Joystick input vector (not normalized).
var input_vector: Vector2 = Vector2.ZERO

## Null-cancelling vector (not normalized).
var null_cancelling_vector: Vector2 = Vector2.ZERO

func _ready() -> void:
	super._ready()
	
	# TODO
	# Initialize variables.
	in_player_control = true
	move_speed = 400
	projectile_speed = 400
	pass

func _process(delta: float) -> void:
	super._process(delta)
	
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
	
	# --- Update Move Vector --- #
	if (in_player_control):
		move_vector = input_vector
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		print("Player shoot.")
		shoot_once(get_global_mouse_position() - self.global_position)
	pass

## Shoot one projectile.
func shoot_once(p_vector: Vector2) -> void:
	var p_velocity: Vector2 = p_vector.normalized() * projectile_speed
	var p_angle: float = Vector2.RIGHT.angle_to(p_vector)
	
	var projectile: _Projectile = projectile_scene.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
	Globals.gameplay.add_projectie_to_scene(projectile)
	projectile.setup_start(self.global_position, p_velocity, p_angle)
	pass

## Hit detection.
func _on_hit_detector_area_entered(area: Area2D) -> void:
	# TODO
	print("Player hit.")
	
	var projectile := area as _Projectile
	if (projectile):
		projectile.despawn()
	
	pass
