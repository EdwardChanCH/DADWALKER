class_name _SonicBoom
extends _Projectile

## Scale to increment per second.
@export var expansion_rate: float = 2

func _process(delta: float) -> void:
	self.scale.y += expansion_rate * delta
	pass
