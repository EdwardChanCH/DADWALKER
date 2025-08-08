class_name _MiniBoss
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
	super._process(delta)
	
	# -- Track Player Or Walk Straight--- #
	if (in_tracking_mode and tracking_object):
		move_vector = tracking_object.global_position - self.global_position
	else:
		move_vector = idle_vector
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
	# TODO
	print("Enemy hit.")
	
	var projectile := area as _Projectile
	if (projectile):
		shoot_batch(projectile.move_velocity, deg_to_rad(10), 2)
	pass
