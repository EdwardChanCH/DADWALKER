extends Control

@export var dialogue: _Dialogue
@export var character_sprite_folder_paths: Dictionary[_DialogueSequence.Characters, String]

@export_category("Node Ref")
@export var character_name_label: Label
@export var dialogue_text_label: Label

# I hate this I hate this I hate this
# Should really make it in to a array but...
# Actually this should be done dynamically
# Can't overkill this
@export var character_sprite_1: _CharacterSprite
@export var character_sprite_2: _CharacterSprite
@export var border : _Border
@export var text_box_animation_player: AnimationPlayer

#@export var character_sprite_texture: Array[Texture2D]

# The current index of the dialogue sequance
var __current_dialogue_index: int = 0

# The position of character
# 0 is left and 1 and right
# There is no such a thing as pair so array will have to do
var __current_character_position: Array[_DialogueSequence.Characters] = [_DialogueSequence.Characters.NONE, _DialogueSequence.Characters.NONE]
var __character_sprite_cache: Dictionary[String, Texture]

func _enter_tree() -> void:
	#character_sprite_folder_paths
	
	for character in character_sprite_folder_paths.keys():
		var paths_list: Array[String] = []
		_AudioManager.get_file_paths(character_sprite_folder_paths[character], paths_list)
		
		for path in paths_list:
			var texture: Texture = load(path)
			var file_name = path.split("/", false)
			var key = file_name[file_name.size() - 1]
			var name = key.split(".", false)
			__character_sprite_cache.set(name[0], texture)
			pass
	
	pass

func _ready() -> void:
	await play_ui_slide_in_animation();
	reset_dialogue_sequance()
	pass

func _gui_input(event: InputEvent) -> void:
	if ( (  event is not InputEventMouseButton) or not dialogue ):
		return
		
	if ( (event.button_index == MOUSE_BUTTON_LEFT) and event.pressed):
		# Can't do current_dialogue_index++ pain
		__current_dialogue_index += 1
		
		var keep_going: bool = await set_dialogue_sequence(__current_dialogue_index)
		
		if ( not keep_going ):
			await play_ui_slide_out_animation()
			visible = false
		print("Clicked")
		
	pass

## Set the current sequence of dialogue to the start
func reset_dialogue_sequance() -> void:
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

	return false

## Set character sprite
func set_character_sequence(sequence: _CharacterSequence) -> void:
	set_character_sprite(sequence.character_position, sequence.character_name, 1)
	pass
	
func set_character_sprite(character_position: _DialogueSequence.Position, character_name: _DialogueSequence.Characters, epression_index: int):
	var target_sprite: TextureRect = null
	match(character_position):
		_DialogueSequence.Position.LEFT:
			target_sprite = character_sprite_1.sprite
			__current_character_position[0] = character_name
			
		_DialogueSequence.Position.RIGHT:
			target_sprite = character_sprite_2.sprite
			__current_character_position[1] = character_name
			
	
	var name: String = _DialogueSequence.Characters.find_key(character_name).to_lower()
	var cache_key = name + "_" + str(epression_index)
	if( not target_sprite):
		return
	
	if (not __character_sprite_cache.has(cache_key)):
		target_sprite.texture = null
		return
	
	target_sprite.texture = __character_sprite_cache[cache_key] as Texture2D
	pass

func set_text(sequence: _TextSequence) -> _DialogueSequence.Position:
	# Set text and name of the sequence
	var character_name = _DialogueSequence.Characters.find_key(sequence.character_name)
	
	dialogue_text_label.text = sequence.sequence_text
	
	if(character_name != "None"):
		character_name_label.text = character_name.capitalize()
	
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

func play_ui_slide_in_animation() -> Signal:
	
	set_character_sequence(dialogue.starting_characters_1)
	set_character_sequence(dialogue.starting_characters_2)
	
	border.play_slide_in_animation()
	character_sprite_1.sprite_animation.play("slide_in_left")
	character_sprite_2.sprite_animation.play("slide_in_right")
	text_box_animation_player.play("slide_in")
	await character_sprite_2.sprite_animation.animation_finished
	return get_tree().create_timer(0.25).timeout

func play_ui_slide_out_animation() -> Signal:
	character_sprite_1.sprite_animation.play_backwards("slide_in_left")
	character_sprite_2.sprite_animation.play_backwards("slide_in_right")
	text_box_animation_player.play_backwards("slide_in")
	await character_sprite_2.sprite_animation.animation_finished
	
	await border.play_slide_out_animation()

	return get_tree().create_timer(0.25).timeout
