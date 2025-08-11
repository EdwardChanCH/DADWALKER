class_name _BossHealth
extends CanvasLayer

@export var animation: AnimationPlayer = null

@export var health_label: Label = null

@export var progress_bar: TextureProgressBar = null

@export var boss_name_label: Label = null

@export var boss_name: String = "Boss Name"

@export var max_health: int = 1_000_000

## Current health.
var current_health: int = 1 :
	get:
		return current_health
	set(value):
		if (value <= 0):
			current_health = 0
			progress_bar.value = 0
		elif (value >= max_health):
			current_health = max_health
			progress_bar.value = 1
		else:
			current_health = value
			progress_bar.value = float(current_health) / float(max_health)
			animation.play("ui_bump")
		health_label.text = str(current_health)
		pass

func _ready() -> void:
	animation.play("default")
	current_health = max_health
	boss_name_label.text = boss_name
	health_label.text = str(ResourceLoader.list_directory("res://"))
	pass

## Open boss health UI.
func open_ui() -> void:
	animation.play("ui_open")
	await animation.animation_finished
	pass

## Close boss health UI.
func close_ui() -> void:
	animation.play("ui_close")
	await animation.animation_finished
	pass
