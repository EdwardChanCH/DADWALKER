class_name _Player
extends _GameObject

@export var collision_box: CollisionShape2D = null

@export var hit_box: CollisionShape2D = null

@export var shadow: Sprite2D = null

@export var shooting_delay: float = 0.2

var __shooting_cooldown: float = 0

var __shooting_pressed: bool = false

## Keyboard/Joystick input vector (not normalized).
var input_vector: Vector2 = Vector2.ZERO

## Null-cancelling vector (not normalized).
var null_cancelling_vector: Vector2 = Vector2.ZERO

func _ready() -> void:
	super._ready()
	
	# Check if missing export variables.
	if (not collision_box
		or not hit_box
		or not shadow):
		push_error("Missing export variables in node '%s'." % [self.name])
	
	# TODO
	# Initialize variables.
	in_player_control = true
	move_speed = 400
	projectile_speed = 1000
	max_health = 3
	current_health = 3
	
	# TODO test only
	# TODO set walking speed
	character_world_node.start_walk()
	
	pass

func _process(delta: float) -> void:
	if (current_health <= 0):
		return # Skip.
	
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
	
	if Input.is_action_pressed("shoot"):
		__shooting_pressed = true
	
	# --- Player Shooting --- #
	if (__shooting_cooldown <= 0):
		__shooting_cooldown = 0
	else:
		__shooting_cooldown -= delta
	
	if (__shooting_pressed and __shooting_cooldown <= 0):
		__shooting_pressed = false
		__shooting_cooldown = shooting_delay
		shoot_once(get_global_mouse_position() - self.global_position)
	
	# --- Update Move Vector --- #
	if (in_player_control):
		move_vector = input_vector
	pass

func _physics_process(delta: float) -> void:
	if (current_health <= 0):
		return # Skip.
	
	super._physics_process(delta)
	pass

## Shoot one projectile.
func shoot_once(p_vector: Vector2) -> void:
	if not projectile_scene:
		return
	
	var projectile: _Projectile = projectile_scene.instantiate()
	if not projectile:
		return
	
	var p_velocity: Vector2 = p_vector.normalized() * projectile_speed
	p_velocity += (move_vector * move_speed).project(p_velocity) # Add player velocity.
	var p_angle: float = Vector2.RIGHT.angle_to(p_vector)
	
	
	if Globals.gameplay:
		Globals.gameplay.add_projectie_to_scene(projectile)
	projectile.setup_start(self.global_position, p_velocity, p_angle)
	pass

## Stomped by final boss.
func stomped() -> void:
	current_health -= 1
	pass

## Restore to full health.
func restore_health() -> void:
	current_health = max_health
	
	# Enable collisions.
	self.collision_layer = __scl
	self.collision_mask = __scm
	hit_detector_node.collision_layer = __hcl
	hit_detector_node.collision_mask = __hcm
	
	# Enable controls.
	in_player_control = true
	pass

## Hit detection.
func _on_hit_detector_area_entered(area: Area2D) -> void:
	var projectile := area as _Projectile
	if (projectile):
		projectile.despawn()
		current_health -= 1
	pass

func _on_health_changed(new_health: int) -> void:
	# Change scale.
	var new_scale: Vector2 = Vector2.ONE * (float(new_health) / float(max_health))
	collision_box.scale = new_scale
	hit_box.scale = new_scale
	shadow.scale = new_scale
	
	if (new_health <= 0 and Globals.lose_menu):
		Globals.lose_menu.visible = true
	
	super._on_health_changed(new_health)
	pass
