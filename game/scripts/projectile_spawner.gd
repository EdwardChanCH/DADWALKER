class_name _ProjectileSpawner
extends Node2D

## Projectile scene as weapon.
@export var projectile_scene: PackedScene = null

@export var projectile_speed: float = 500

## Shoot one projectile.
func shoot_once(p_vector: Vector2) -> _Projectile:
	if not projectile_scene:
		return
	
	var projectile: _Projectile = projectile_scene.instantiate()
	if not projectile:
		return
	
	var p_velocity: Vector2 = p_vector * projectile_speed
	var p_angle: float = Vector2.RIGHT.angle_to(p_vector)
	
	if Globals.gameplay:
		Globals.gameplay.add_projectie_to_scene(projectile)
	projectile.setup_start(self.global_position, p_velocity, p_angle)
	
	return projectile
