class_name _DialogueUI
extends CanvasLayer

signal finish_dialogue
signal ui_close
signal ui_open

@export var none_texture: Texture2D = null

@export_category("Resources")
@export var dialogue: _Dialogue
@export var character_sprite_folder_paths: Dictionary[_DialogueSequence.Characters, String]

@export_category("UI Node")
@export var character_name_label: RichTextLabel
@export var dialogue_text_label: RichTextLabel
@export var text_box_background: Panel

@export var character_sprite_1: _CharacterSprite
@export var character_sprite_2: _CharacterSprite
@export var text_box_animation_player: AnimationPlayer

@export var doki_color: Color = Color(255.0/255.0, 200.0/255.0, 48.0/255.0)
@export var dad_color: Color = Color(90.0/255.0, 80.0/255.0, 130.0/255.0) #Color(65.0/255.0, 57.0/255.0, 96.0/255.0)
@export var dragoon_color: Color = Color(255.0/255.0, 244.0/255.0, 193.0/255.0)

@export_category("Text Delay")
#@export var text_delay: float = 0.02
var is_typing: bool = false
var should_skip_typing: bool = false
var typeing_timer: SceneTreeTimer

# The current index of the dialogue sequance
var __current_dialogue_index: int = 0

# The position of character
# 0 is left and 1 and right
# There is no such a thing as pair so array will have to do
var __current_character_position: Array[_DialogueSequence.Characters] = [_DialogueSequence.Characters.NONE, _DialogueSequence.Characters.NONE]

var __character_sprite_cache: Dictionary[String, Texture]

var __character_limit: float = -0.5 # Hide all letters.

func _enter_tree() -> void:
	for character in character_sprite_folder_paths.keys():
		var paths_list: Array[String] = []
		AudioManager.get_file_paths(character_sprite_folder_paths[character], paths_list)
		
		for path in paths_list:
			var texture: Texture = load(path)
			var file_name = path.split("/", false)
			var key = file_name[file_name.size() - 1]
			var name_extendionless = key.split(".", false)
			__character_sprite_cache.set(name_extendionless[0], texture)
			pass
	pass

func _ready() -> void:
	visible = false
	Globals.dialogue_ui = self
	__character_limit = -0.5 # Hide all letters.
	pass

func _process(delta: float) -> void:
	if (__character_limit <= -1):
		__character_limit = -1
		pass # Show all letters.
	elif (__character_limit < 0):
		__character_limit = -0.5
		pass # Hide all letters.
	else:
		__character_limit += Globals.text_display_speed * delta
		if (dialogue_text_label.visible_characters > dialogue_text_label.text.length()):
			dialogue_text_label.visible_characters = -1
			is_typing = false
		else:
			dialogue_text_label.visible_characters = int(__character_limit)
	pass

func _on_control_gui_input(event: InputEvent) -> void:
	
	if ( (  event is not InputEventMouseButton) or not dialogue ):
		return
	
	# Unsafe type conversion.
	#if ( (event.button_index == MOUSE_BUTTON_LEFT) and event.pressed):
	if (event.is_action_pressed("next_dialogue")):
		# Double clicked.
		# Finish all current animations.
		if (text_box_animation_player.is_playing()):
			text_box_animation_player.advance(0)
		if (character_sprite_1.sprite_animation.is_playing()):
			character_sprite_1.sprite_animation.advance(0)
		if (character_sprite_2.sprite_animation.is_playing()):
			character_sprite_2.sprite_animation.advance(0)
		
		if (is_typing):
			skip_text_type_effect()
			return
			
		# Can't do current_dialogue_index++ pain
		__current_dialogue_index += 1
		
		var keep_going: bool = await set_dialogue_sequence(__current_dialogue_index)
		if ( not keep_going ):
			finish_dialogue.emit()
			await play_ui_slide_out_animation()
			visible = false
		#print("Clicked")
		
	pass

## Set the current sequence of dialogue to the start
func reset_dialogue_sequance() -> void:
	set_character_sequence(dialogue.starting_characters_1)
	set_character_sequence(dialogue.starting_characters_2)
	set_dialogue_sequence(0);
	pass

## Set the current sequence of dialogue
func set_dialogue_sequence(new_sequence: int) -> bool:
	
	# Check if the sequence is valid
	if ( dialogue.sequence.size() - 1 < new_sequence ):
		return false
	
	var current_sequence = dialogue.sequence[new_sequence]
	
	if(current_sequence is _TextSequence):	
		var character_position = set_text(current_sequence)
		
		# Spelling colour the right way
		# Hard coded in
		# Don't have enengy for a system that set the character
		var text_box_colour: Color = Color.GRAY
		match current_sequence.character_name:
			_DialogueSequence.Characters.DOKI:
				text_box_colour = doki_color
				pass
			_DialogueSequence.Characters.DAD:
				text_box_colour = dad_color
				pass
			_DialogueSequence.Characters.DRAGOON:
				text_box_colour = dragoon_color
				pass
			
		text_box_background.self_modulate = text_box_colour;
		#character_name_label.self_modulate = text_box_colour;
		
		if(character_position != _DialogueSequence.Position.NONE):
			set_character_sprite(character_position, current_sequence.character_name, current_sequence.expression)
			await play_sprite_ui_animation(character_position, "talk").animation_finished
			await get_tree().create_timer(0.25).timeout
		return true
	
	if(current_sequence is _CharacterSequence):
		if(current_sequence.play_animation):
			var string = _DialogueSequence.Position.find_key(current_sequence.character_position).to_lower()
			await play_sprite_ui_animation(current_sequence.character_position, "slide_in_" + string, true).animation_finished
			set_character_sequence(current_sequence)
			await play_sprite_ui_animation(current_sequence.character_position, "slide_in_" + string).animation_finished
		else:
			set_character_sequence(current_sequence)

		__current_dialogue_index += 1
		set_dialogue_sequence(__current_dialogue_index)
		return true

	if(current_sequence is _SpriteAniatmionSequence):
		await play_sprite_ui_animation(current_sequence.target_position, current_sequence.animation_name).animation_finished
		__current_dialogue_index += 1
		set_dialogue_sequence(__current_dialogue_index)
		return true

	if(current_sequence is _SoundSequence):
		__current_dialogue_index += 1
		set_dialogue_sequence(__current_dialogue_index)
		return true

	return false

## Set the current character who are on screen
func set_character_sequence(sequence: _CharacterSequence) -> void:
	var sprite: TextureRect = set_character_sprite(sequence.character_position, sequence.character_name, 1)
	
	sprite.flip_h = sequence.flip_sprite
	pass

## Set character sprite
func set_character_sprite(character_position: _DialogueSequence.Position, character_name: _DialogueSequence.Characters, epression_index: int) -> TextureRect:
	var target_sprite: TextureRect = null
	match(character_position):
		_DialogueSequence.Position.LEFT:
			target_sprite = character_sprite_1.sprite
			__current_character_position[0] = character_name
			
		_DialogueSequence.Position.RIGHT:
			target_sprite = character_sprite_2.sprite
			__current_character_position[1] = character_name
			
	
	var lower_name: String = _DialogueSequence.Characters.find_key(character_name).to_lower()
	var cache_key = lower_name + "_" + str(epression_index)
	if( not target_sprite):
		#print("set_character_sprite: Invalid character_position.")
		return
	
	if (not __character_sprite_cache.has(cache_key)):
		#print("set_character_sprite: Invalid cache_key.")
		#target_sprite.texture = null
		#return
		
		# This costed 2 hours to fix.
		target_sprite.texture = none_texture
		return target_sprite
	
	target_sprite.texture = __character_sprite_cache[cache_key] as Texture2D
	return target_sprite

## Set text
func set_text(sequence: _TextSequence) -> _DialogueSequence.Position:
	# Set text and name of the sequence
	var character_name = _DialogueSequence.Characters.find_key(sequence.character_name)
	
	#dialogue_text_label.text = sequence.sequence_text
	text_type_effect(sequence.sequence_text, sequence.character_name)
	
	if(sequence.character_name != _DialogueSequence.Characters.NONE):
		character_name_label.text = character_name.capitalize()
	
	# Change the colour of the sprite depending on who is talking
	if(__current_character_position[0] == sequence.character_name):
		character_sprite_1.modulate = Color(1, 1, 1)
		character_sprite_2.modulate = Color(0.5, 0.5, 0.5)
		return _DialogueSequence.Position.LEFT

	if (__current_character_position[1] == sequence.character_name):
		character_sprite_1.modulate = Color(0.5, 0.5, 0.5)
		character_sprite_2.modulate = Color(1, 1, 1)
		return _DialogueSequence.Position.RIGHT
	
	character_sprite_1.modulate = Color(0.5, 0.5, 0.5)
	character_sprite_2.modulate = Color(0.5, 0.5, 0.5)
	return _DialogueSequence.Position.NONE

func text_type_effect(text: String, character_name: _DialogueSequence.Characters) -> void:
	should_skip_typing = false
	is_typing = true
	#dialogue_text_label.text = ""
	dialogue_text_label.text = text
	__character_limit = 0.001 # Show the first letter.
	
	var path: String
	match character_name:
		_DialogueSequence.Characters.DOKI:
			path = "res://assets/sounds/sfx/sfx_npc_dokibirdblip1_fd1.ogg"
			pass
		_DialogueSequence.Characters.DAD:
			path = "res://assets/sounds/sfx/sfx_npc_dadblip1_fd1.ogg"
			pass
		_DialogueSequence.Characters.DRAGOON:
			path = "res://assets/sounds/sfx/sfx_pc_dragoonblip_fd1.ogg"
			pass
	
	#var audio_player: AudioStreamPlayer = AudioManager.get_audio_steam_player(path)
	
	#for character in text:
		#if(should_skip_typing):
		#	dialogue_text_label.text = text
		#	break
		
		#if (not audio_player.playing):
		#	AudioManager.play_sfx(path, 0.25) # TODO
			#audio_player.play()

		# This causes a bug where multiple dialogues type to the texet box at the same time...
		#dialogue_text_label.text += character
		#typeing_timer = get_tree().create_timer(1.0 / Globals.text_display_speed)
		#await typeing_timer.timeout
		
	#is_typing = false
	pass

func skip_text_type_effect() -> void:
	is_typing = false
	__character_limit = -1.0
	dialogue_text_label.visible_characters = -1
	
	should_skip_typing = true
	if (typeing_timer):
		typeing_timer.timeout.emit()
	return


## Play simple sprite animation
func play_sprite_ui_animation(character_position: _DialogueSequence.Position, animation_name: String, play_backwards: bool = false) -> AnimationPlayer:
	var target_animation_player: AnimationPlayer = null
	match(character_position):
		_DialogueSequence.Position.LEFT:
			target_animation_player = character_sprite_1.sprite_animation
			
		_DialogueSequence.Position.RIGHT:
			target_animation_player = character_sprite_2.sprite_animation
	
	if(play_backwards):
		target_animation_player.play_backwards(animation_name)
	else:
		target_animation_player.play(animation_name)
	
	return target_animation_player

## Play ui slide in animation
func play_ui_slide_in_animation() -> Signal:	
	character_sprite_1.sprite_animation.play("slide_in_left")
	character_sprite_2.sprite_animation.play("slide_in_right")
	text_box_animation_player.play("slide_in")
	await character_sprite_1.sprite_animation.animation_finished
	return get_tree().create_timer(0.25).timeout

## Play ui slide out animation
func play_ui_slide_out_animation() -> Signal:
	character_sprite_1.sprite_animation.play_backwards("slide_in_left")
	character_sprite_2.sprite_animation.play_backwards("slide_in_right")
	text_box_animation_player.play_backwards("slide_in")
	await character_sprite_1.sprite_animation.animation_finished
	return get_tree().create_timer(0.25).timeout

## Start dialogue
func start_dialgoue(new_dialogue: _Dialogue) -> void:
	dialogue = new_dialogue
	reset_dialogue_sequance()
	visible = true
	play_ui_slide_in_animation()
	pass

func _on_visibility_changed() -> void:
	if (!visible):
		ui_close.emit()
		return
	ui_open.emit()
	pass
