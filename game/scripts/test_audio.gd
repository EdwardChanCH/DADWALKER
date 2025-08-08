extends Node2D
@export var audio: AudioStream

func _ready() -> void:
	_AudioManager.play_sfx(audio)
	pass
