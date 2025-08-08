extends Node2D
@export var audio: AudioStream

func _ready() -> void:
	_AudioManager.play_sfx("res://assets/sound/sfx/test/bang.wav")
	_AudioManager.play_music("res://assets/sound/bgm/test/infinite_perspective_short.wav")
	
	pass
