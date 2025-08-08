class_name _BasicEnemy
extends _GameObject

## Can follow game objects or not.
@export var in_tracking_mode: bool = false

## Object to track (usually the player).
@export var tracking_object: Node2D = null

## Vector when not in tracking mode (not normalized).
var idle_vector: Vector2 = Vector2.LEFT

func _ready() -> void:
	super._ready()
	
	# TODO
	# Initialize variables.
	in_logic_control = true
	move_speed = 200
	projectile_speed = 200
	pass

func _process(delta: float) -> void:
	if (current_health <= 0):
		return # Skip.
	
	super._process(delta)
	
	# -- Track Player Or Walk Straight--- #
	if (in_tracking_mode and tracking_object):
		move_vector = tracking_object.global_position - self.global_position
	else:
		move_vector = idle_vector
	pass

func _physics_process(delta: float) -> void:
	if (current_health <= 0):
		return # Skip.
	
	super._physics_process(delta)
	pass

## Shoot one batch of projectiles.
## p_count must be an odd number.
## Total projectiles = (1 + 2 * p_count).
func shoot_batch(incoming_vector: Vector2, p_spread: float, p_count: int) -> void:
	# Straight shot.
	shoot_once(incoming_vector)
	
	# Angled shots.
	for i: int in range(1, p_count + 1):
		shoot_once(incoming_vector.rotated(i * p_spread))
		shoot_once(incoming_vector.rotated(i * -p_spread))
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
	# Prevent self damage.
	#if (current_health <= 0):
	#	return # Skip.
	
	var projectile := area as _Projectile
	
	if (current_health > 0 and projectile):
		print("Enemy hit.")
		if (projectile is _Feather):
			current_health -= 1
		elif (projectile is _Seed):
			current_health = 0
		elif (projectile is _Bullet):
			current_health = 0
		elif (projectile is _SonicBoom):
			current_health = 0
			
		if (current_health <= 0):
			_on_death()
			
			# Spawn seeds.
			shoot_batch(projectile.move_velocity, deg_to_rad(15), 1)
		
		# Despawn incoming projectile.
		projectile.despawn()
	pass

func _on_death() -> void:
	# Disable collisions.
	self.collision_layer = 0
	self.collision_mask = 0
	hit_detector_node.collision_layer = 0
	hit_detector_node.collision_mask = 0
	
	# Disable controls.
	in_sequence_control = false
	in_logic_control = false
	in_player_control = false
	
	# Play death animation.
	character_world_node.start_death()
	pass
