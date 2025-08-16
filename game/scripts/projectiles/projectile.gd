class_name _Projectile
extends Area2D

signal despawned

## Projectile sprite.
@export var sprite: Sprite2D = null

## Automatic queue free.
@export var lifetime_max: float = 10

var __lifetime_timer: float = 0

## Movement direction + speed.
var move_velocity: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	if (not move_velocity.is_zero_approx()):
		self.global_position += move_velocity * delta
	
	__lifetime_timer += delta
	if (__lifetime_timer > lifetime_max):
		self.queue_free()
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
	# This may cause issues if another enemy touches it at the same tick.
	#move_velocity = Vector2.ZERO
	despawned.emit()
	self.queue_free()
	pass
