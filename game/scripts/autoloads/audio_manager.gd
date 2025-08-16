#class_name _AudioManager
extends Node

enum AudioType
{
	MASTER,
	SFX,
	UI,
	MUSIC,
	VOICE,
}

const SOUND_PATH: String = "res://assets/sounds/"

var __sound_cache: Dictionary[String, AudioStream]

var __sfx_channels: Dictionary[AudioStream, AudioStreamPlayer]
var __voice_channel: AudioStreamPlayer
var __music_channel: AudioStreamPlayer

var audio_path_list: Array[String]

func _enter_tree() -> void:
	
	# Note: AudioManager is already a singleton node.
	#       Access it with AudioManager instead of AudioManager._instance.
	
	# Sington stuff
	#if(_instance != null):
	#	push_warning("There is already an audio manager")
	#	queue_free()
	#	return
		
	#_instance = self
	
	#ProcessMode = ProcessMode.
	
	__voice_channel = AudioStreamPlayer.new()
	__voice_channel.name = "VoiceChannel"
	__voice_channel.bus = "Voice"
	add_child(__voice_channel)
	
	__music_channel = AudioStreamPlayer.new()
	__music_channel.name = "MusicChannel"
	__music_channel.bus = "Music"
	__music_channel.finished.connect(_music_loop)
	add_child(__music_channel)
	
	
	var files: Array[String]
	get_file_paths(SOUND_PATH,files)
	
	for item in files:
		var audio_steam: AudioStream = load(item)
		__sound_cache.set(item, audio_steam)
		
	audio_path_list = files
	pass

func create_sfx_channel(sfx: AudioStream) -> AudioStreamPlayer:
	var sfx_channel = AudioStreamPlayer.new()
	sfx_channel.name = "SFXChannel" + str(__sfx_channels.size())
	sfx_channel.bus = "SFX"
	sfx_channel.stream = sfx
	sfx_channel.process_mode = Node.PROCESS_MODE_PAUSABLE
	sfx_channel.max_polyphony = 4
	add_child(sfx_channel)
	
	__sfx_channels.set(sfx, sfx_channel)
	return sfx_channel

func _music_loop() -> void:
	__music_channel.play()
	pass

func get_audio_steam_player(sound_path: String) -> AudioStreamPlayer:
	var target_channel: AudioStreamPlayer = null
	if (not AudioManager.__sound_cache.has(sound_path)):
		return null
	
	var audio_steam: AudioStream = AudioManager.__sound_cache[sound_path]
	
	
	if (not AudioManager.__sfx_channels.has(audio_steam)):
		AudioManager.create_sfx_channel(audio_steam)
	
	target_channel = AudioManager.__sfx_channels[audio_steam]
	return target_channel

func get_file_paths(path: String, files: Array[String]) -> void:
	var list = ResourceLoader.list_directory(path)
	for item in list:
		if(item.ends_with("/")):
			var new_path = path + item
			get_file_paths(new_path, files)
			continue
		files.append(path+item)
	pass

func play_sfx(sound_path: String, volume_linear: float = 1.0) -> AudioStreamPlayer:
	
	var target_channel: AudioStreamPlayer = null
	
	if (not AudioManager.__sound_cache.has(sound_path)):
		return null
	
	var audio_steam: AudioStream = AudioManager.__sound_cache[sound_path]
	
	
	if (not AudioManager.__sfx_channels.has(audio_steam)):
		AudioManager.create_sfx_channel(audio_steam)
	
	target_channel = AudioManager.__sfx_channels[audio_steam]
		
	target_channel.volume_linear = volume_linear
	target_channel.play()

	return target_channel

func play_voice(sound_path: String, volume_linear: float = 1.0) -> void:
	var audio_steam: AudioStream = __sound_cache[sound_path]
	__voice_channel.stop()
	__voice_channel.stream = audio_steam
	__voice_channel.volume_linear = volume_linear
	__voice_channel.play()
	pass
	
func play_music(sound_path: String, volume_linear: float = 1.0) -> void:
	var audio_steam: AudioStream = AudioManager.__sound_cache[sound_path]
	__music_channel.stop()
	__music_channel.stream = audio_steam
	__music_channel.volume_linear = volume_linear
	__music_channel.play()
	pass

func set_volume(type: AudioType, volume_linear: float) -> void:
	var index: int = type as int
	AudioServer.set_bus_volume_linear(index, volume_linear)
	pass
