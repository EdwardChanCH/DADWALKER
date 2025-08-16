class_name _Feather
extends _Projectile

@export var texture_fast: CompressedTexture2D = null

@export var texture_medium: CompressedTexture2D = null

@export var texture_slow: CompressedTexture2D = null

var velocity_decay: float = 3

var fade_speed_sq: float = (100 * 100)

var despawn_speed_sq: float = (10 * 10)

var speed_stage_2_limit: int = (500 * 500)

var speed_stage_1_limit: int = (200 * 200)

var speed_stage: int = 3

func _process(delta: float) -> void:
	move_velocity = move_velocity.lerp(Vector2.ZERO, Globals.lerp_t(velocity_decay, delta))
	
	var move_speed_sq: float = move_velocity.length_squared()
	if (move_speed_sq < despawn_speed_sq):
		self.despawn()
	elif (move_speed_sq < fade_speed_sq):
		sprite.self_modulate.a = (move_speed_sq / fade_speed_sq)
	
	if (speed_stage > 2 and move_speed_sq < speed_stage_2_limit):
		speed_stage = 2
		sprite.texture = texture_medium
	elif (speed_stage > 1 and move_speed_sq < speed_stage_1_limit):
		speed_stage = 1
		sprite.texture = texture_slow
	pass
