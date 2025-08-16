class_name _EnemyTrigger
extends Area2D

signal camera_in_range

func trigger() -> void:
	camera_in_range.emit()
	self.queue_free()
	pass
