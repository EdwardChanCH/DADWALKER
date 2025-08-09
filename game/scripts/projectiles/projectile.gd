class_name _Projectile
extends Area2D

signal despawned

## Projectile sprite.
@export var sprite: Sprite2D = null

## Movement direction + speed.
var move_velocity: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	if (not move_velocity.is_zero_approx()):
		self.global_position += move_velocity * delta
	pass

## Activate the bullet.
func setup_start(p_global_position: Vector2, p_velocity: Vector2, p_rotation: float) -> void:
	self.global_transform.origin = p_global_position
	self.reset_physics_interpolation()
	move_velocity = p_velocity
	sprite.rotation = p_rotation
	pass

## Despawn animation.
func despawn() -> void:
	# TODO add animation
	move_velocity = Vector2.ZERO
	despawned.emit()
	self.queue_free()
	pass
