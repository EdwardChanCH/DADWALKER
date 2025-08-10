extends CanvasLayer

@export_category("UI Node")
@export var master_slider: Slider
@export var sfx_slider: Slider
@export var ui_slider: Slider
@export var music_slider: Slider
@export var voice_slider: Slider

func _ready() -> void:
	var master_arg = [master_slider, _AudioManager.AudioType.MASTER]
	master_slider.drag_ended.connect(Callable(update_volume).bind(master_arg))
	
	var sfx_arg = [sfx_slider, _AudioManager.AudioType.SFX]
	sfx_slider.drag_ended.connect(Callable(update_volume).bind(sfx_arg))
	
	var ui_arg = [ui_slider, _AudioManager.AudioType.UI]
	ui_slider.drag_ended.connect(Callable(update_volume).bind(ui_arg))
	
	var music_arg = [music_slider, _AudioManager.AudioType.MUSIC]
	music_slider.drag_ended.connect(Callable(update_volume).bind(music_arg))
	
	var voice = [voice_slider, _AudioManager.AudioType.VOICE]
	voice_slider.drag_ended.connect(Callable(update_volume).bind(voice))	
	pass
	
func update_volume(_changed: bool, arg_array: Array) -> void:
	var slider: Slider = arg_array[0] as Slider
	_AudioManager.set_volume(arg_array[1], slider.value)
	pass


func _on_close_button_pressed() -> void:
	queue_free()
	pass
