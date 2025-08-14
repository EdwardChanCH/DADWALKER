class_name _SettingMenu
extends CanvasLayer

signal ui_close
signal ui_open

@export_category("UI Node")
@export var master_slider: Slider
@export var sfx_slider: Slider
@export var ui_slider: Slider
@export var music_slider: Slider
@export var voice_slider: Slider
@export var ui_control: Control
@export var ui_animation_player: AnimationPlayer
@export var display_speed : Label

func _ready() -> void:
	
	# Could have just done this in the editor itself
	# But it takes too much time to change it now 
	# So this will have to do
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
	
	visible = false
	Globals.setting_menu = self
	pass
	
func update_volume(_changed: bool, arg_array: Array) -> void:
	var slider: Slider = arg_array[0] as Slider
	AudioManager.set_volume(arg_array[1], slider.value)
	pass

func _on_close_button_pressed() -> void:
	ui_animation_player.play("slide_out", -1, 1.5)
	await ui_animation_player.animation_finished
	visible = false
	pass

# Get call when the visibility is changed
func _on_visibility_changed() -> void:
	
	# Emit a singal and pause control node when visible is set to false
	if (!visible):
		ui_close.emit()
		ui_control.process_mode = Node.PROCESS_MODE_DISABLED
		return
	
	# Emit a singal and slide in animation when visible set to true
	ui_animation_player.play("slide_in")
	await ui_animation_player.animation_finished
	
	# Unpause control node after the animation is finish
	ui_open.emit()
	ui_control.process_mode = Node.PROCESS_MODE_INHERIT
	pass

func _on_god_mode_button_toggled(toggled_on: bool) -> void:
	Globals.god_mode = toggled_on
	pass

func _on_fps_counter_button_toggled(toggled_on: bool) -> void:
	Globals.show_fps_count = toggled_on
	pass


func _on_display_speed_slider_value_changed(value: float) -> void:
	Globals.text_display_speed = value
	display_speed.text = str(value).pad_decimals(2) + "S"
	pass # Replace with function body.
