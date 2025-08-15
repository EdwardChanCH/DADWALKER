extends CanvasLayer
@export var audio: AudioStream

@export var master_slider: Slider
@export var sfx_slider: Slider
@export var ui_slider: Slider
@export var music_slider: Slider
@export var voice_slider: Slider

@export var audio_list: ItemList
@export var audio_option: OptionButton
@export var play_button: Button

var selected_audio: String
var play_option: int

func _ready() -> void:
	var master_arg = [master_slider, AudioManager.AudioType.MASTER]
	master_slider.drag_ended.connect(Callable(update_volume).bind(master_arg))
	
	var sfx_arg = [sfx_slider, AudioManager.AudioType.SFX]
	sfx_slider.drag_ended.connect(Callable(update_volume).bind(sfx_arg))
	
	var ui_arg = [ui_slider, AudioManager.AudioType.UI]
	ui_slider.drag_ended.connect(Callable(update_volume).bind(ui_arg))
	
	var music_arg = [music_slider, AudioManager.AudioType.MUSIC]
	music_slider.drag_ended.connect(Callable(update_volume).bind(music_arg))
	
	var voice = [voice_slider, AudioManager.AudioType.VOICE]
	voice_slider.drag_ended.connect(Callable(update_volume).bind(voice))	
	
	for path in AudioManager.audio_path_list:
		if(path.contains("bgm")):
			continue
			
		audio_list.add_item(path)
		selected_audio = path
		
	audio_list.item_selected.connect(set_selected_audio)
	audio_option.item_selected.connect(set_play_option)
	play_button.pressed.connect(play_audio)
	
	self.hide()
	pass

func update_volume(_changed: bool, arg_array: Array) -> void:
	var slider: Slider = arg_array[0] as Slider
	AudioManager.set_volume(arg_array[1], slider.value)
	pass

func set_selected_audio(index: int) -> void:
	selected_audio = audio_list.get_item_text(index)
	pass

func set_play_option(index: int) -> void:
	play_option = index
	pass
	
func play_audio() -> void:
	match (play_option):
		0:
			AudioManager.play_sfx(selected_audio)
		1:
			print("No ui function yet; too lazy to make it")
		2:
			AudioManager.play_music(selected_audio)
		3:
			AudioManager.play_voice(selected_audio)
	pass


func _on_back_button_pressed() -> void:
	#queue_free()
	self.hide()
	pass
