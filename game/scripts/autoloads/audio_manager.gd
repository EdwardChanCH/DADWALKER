class_name _AudioManager
extends Node

enum AudioType
{
	MASTER,
	SFX,
	UI,
	MUSIC,
	VOICE,
}

static var _instance: _AudioManager = null

static var __sound_cache: Dictionary[String, AudioStream]

static var __sfx_channels: Dictionary[AudioStream, AudioStreamPlayer]
static var __voice_channel: AudioStreamPlayer
static var __music_channel: AudioStreamPlayer

func _ready() -> void:
	
	# Sington stuff
	if(_instance != null):
		push_warning("There is already an audio manager")
		queue_free()
		return
		
	_instance = self
	
	#ProcessMode = ProcessMode.
	
	__voice_channel = AudioStreamPlayer.new()
	__voice_channel.name = "VoiceChannel"
	__voice_channel.bus = "Voice"
	add_child(__voice_channel)
	
	__music_channel = AudioStreamPlayer.new()
	__music_channel.name = "MusicChannel"
	__music_channel.bus = "Music"
	add_child(__music_channel)
	
	
	#DirAccess.open("res://assets/sound/")
	#print(ResourceLoader.list_directory("res://assets/sound/")[0])
	var files: Array[String]
	files.append("res://assets/sound/")
	get_sub_directories("res://assets/sound/",files)
	
	for dir in files:
		var path = ResourceLoader.list_directory(dir)
		#for sound_path in path:
			#pass
			
		print(path)
		
	pass

func get_sub_directories(path: String, files: Array[String]) -> void:
	var dir = DirAccess.open(path)
	if(not dir):
		return
	
	dir.list_dir_begin()
	
	var file_name = dir.get_next()
	# No do while loop yay
	while file_name != "":
		if(dir.current_is_dir()):
			var new_dir_path: String
			new_dir_path = path + file_name + "/"
			files.append(new_dir_path)
			get_sub_directories(new_dir_path, files)
		file_name = dir.get_next()
	pass


func create_sfx_channel(sfx: AudioStream) -> AudioStreamPlayer:
	var sfx_channel = AudioStreamPlayer.new()
	sfx_channel.name = "SFXChannel" + str(__sfx_channels.size())
	sfx_channel.bus = "SFX"
	sfx_channel.process_mode = Node.PROCESS_MODE_PAUSABLE
	add_child(sfx_channel)
	
	__sfx_channels.set(sfx, sfx_channel)
	return sfx_channel

static func play_sfx(sfx: AudioStream, volume_linear: float = 1.0) -> AudioStreamPlayer:
	
	var target_channel: AudioStreamPlayer = null
	
	if(not __sfx_channels.has(sfx)):
		_instance.create_sfx_channel(sfx)
	
	target_channel = __sfx_channels[sfx]
	target_channel.volume_linear = volume_linear
	target_channel.play()
	return target_channel
