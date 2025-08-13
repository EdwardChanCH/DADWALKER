class_name _BasicEnemy
extends _GameObject

func _ready() -> void:
	super._ready()
	
	if (Globals.gameplay):
		tracking_object = Globals.gameplay.player
	
	# TODO
	# Initialize variables.
	in_logic_control = true
	move_speed = 200
	projectile_speed = 300
	
	# TODO test only
	# TODO set walking speed
	character_world_node.start_walk()
	pass

func _process(delta: float) -> void:
	super._process(delta)
	
	# -- Track Player Or Walk Straight--- #
	if (current_health <= 0):
		pass
	elif (in_tracking_mode and tracking_object):
		move_vector = tracking_object.global_position - self.global_position
	else:
		move_vector = idle_vector
	pass

func _physics_process(delta: float) -> void:
	if (current_health <= 0):
		return # Skip.
	
	# Allow being pushed.
	push_velocity = push_velocity.lerp(Vector2.ZERO, Globals.lerp_t(push_decay, delta))
	for index: int in self.get_slide_collision_count():
		var collision: KinematicCollision2D = self.get_slide_collision(index)
		var collider: _GameObject = collision.get_collider() as _GameObject
		var collider_normal: Vector2 = collision.get_normal()
		
		if (collider):
			if (collider is _Player):
				# Player can apply push velocity.
				push_velocity = collider_normal * push_speed
				
				# Apply damage to player
				collider.current_health -= 1
			elif (collider is _BasicEnemy):
				# Use the larger vector instead of adding (to prevent sticking).
				if (push_velocity.length_squared() < collider.push_velocity.length_squared()):
					push_velocity = collider.push_velocity
				else:
					pass
	
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
	if not projectile_scene:
		return
	
	var projectile: _Projectile = projectile_scene.instantiate()
	if not projectile:
		return
	
	var p_velocity: Vector2 = p_vector.normalized() * projectile_speed
	var p_angle: float = Vector2.RIGHT.angle_to(p_vector)
	
	if Globals.gameplay:
		Globals.gameplay.add_projectie_to_scene(projectile)
	projectile.setup_start(self.global_position, p_velocity, p_angle)
	pass

## Stomped by final boss.
func stomped() -> void:
	current_health = 0
	shoot_batch(Vector2.RIGHT * projectile_speed, deg_to_rad(40), 1)
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
			# Spawn seeds.
			shoot_batch(projectile.move_velocity, deg_to_rad(15), 1)
		
		# Despawn incoming projectile.
		projectile.despawn()
	pass
