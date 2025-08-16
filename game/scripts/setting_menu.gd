class_name _SettingMenu
extends CanvasLayer

signal ui_close
signal ui_open

@export_category("UI Node")
@export var master_slider: Slider
@export var sfx_slider: Slider
@export var music_slider: Slider
@export var text_delay_slider: Slider
@export var god_mode_button: CheckButton
@export var show_fps_button: CheckButton

@export var ui_control: Control
@export var ui_animation_player: AnimationPlayer
@export var display_speed : Label
@export var master_percentage: Label
@export var sfx_percentage: Label
@export var music_percentage: Label

func _ready() -> void:
	
	# Could have just done this in the editor itself
	# But it takes too much time to change it now 
	# So this will have to do
	#var master_arg = [master_slider, AudioManager.AudioType.MASTER]
	#master_slider.drag_ended.connect(Callable(update_volume).bind(master_arg))
	#var sfx_arg = [sfx_slider, AudioManager.AudioType.SFX]
	#sfx_slider.drag_ended.connect(Callable(update_volume).bind(sfx_arg))
	#var music_arg = [music_slider, AudioManager.AudioType.MUSIC]
	#music_slider.drag_ended.connect(Callable(update_volume).bind(music_arg))
	
	master_slider.drag_ended.connect(Callable(update_volume).bind(master_slider, AudioManager.AudioType.MASTER))
	sfx_slider.drag_ended.connect(Callable(update_volume).bind(sfx_slider, AudioManager.AudioType.SFX))
	music_slider.drag_ended.connect(Callable(update_volume).bind(music_slider, AudioManager.AudioType.MUSIC))
	
	update_volume(true, master_slider, AudioManager.AudioType.MASTER)
	update_volume(true, sfx_slider, AudioManager.AudioType.SFX)
	update_volume(true, music_slider, AudioManager.AudioType.MUSIC)
	
	visible = false
	Globals.setting_menu = self
	
	Globals.god_mode = god_mode_button.button_pressed
	Globals.show_fps_count = show_fps_button.button_pressed
	Globals.text_display_speed = int(text_delay_slider.value)
	pass
	
#func update_volume(_changed: bool, arg_array: Array) -> void:
#	var slider: Slider = arg_array[0] as Slider
#	AudioManager.set_volume(arg_array[1], slider.value)
#	pass

func update_volume(_changed: bool, slider: Slider, audio_type: AudioManager.AudioType) -> void:
	AudioManager.set_volume(audio_type, slider.value)
	
	# Need to update the labels as well.
	match audio_type:
		AudioManager.AudioType.MASTER:
			_on_master_volume_slider_value_changed(slider.value)
		AudioManager.AudioType.SFX:
			_on_sfx_volume_slider_value_changed(slider.value)
		AudioManager.AudioType.MUSIC:
			_on_music_volume_slider_value_changed(slider.value)
		_:
			pass
	pass

func _on_mouse_entered() -> void:
	AudioManager.play_sfx("res://assets/sounds/sfx/sfx_ui_cursor_fd1.ogg", 0.5)
	pass

func _on_close_button_pressed() -> void:
	AudioManager.play_sfx("res://assets/sounds/sfx/sfx_ui_back_fd1.ogg", 0.5)
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
	AudioManager.play_sfx("res://assets/sounds/sfx/sfx_ui_cursor_fd1.ogg", 0.5)
	Globals.god_mode = toggled_on
	pass

func _on_fps_counter_button_toggled(toggled_on: bool) -> void:
	AudioManager.play_sfx("res://assets/sounds/sfx/sfx_ui_cursor_fd1.ogg", 0.5)
	Globals.show_fps_count = toggled_on
	pass

func _on_display_speed_slider_value_changed(value: float) -> void:
	Globals.text_display_speed = int(value)
	display_speed.text = str(int(value))
	pass

func _on_master_volume_slider_value_changed(value: float) -> void:
	master_percentage.text = "%d%%" % [roundf(value * 100)]
	pass

func _on_sfx_volume_slider_value_changed(value: float) -> void:
	sfx_percentage.text = "%d%%" % [roundf(value * 100)]
	pass

func _on_music_volume_slider_value_changed(value: float) -> void:
	music_percentage.text = "%d%%" % [roundf(value * 100)]
	pass

func _on_slider_drag_ended(_value_changed: bool) -> void:
	AudioManager.play_sfx("res://assets/sounds/sfx/sfx_ui_cursor_fd1.ogg", 0.5)
	pass
