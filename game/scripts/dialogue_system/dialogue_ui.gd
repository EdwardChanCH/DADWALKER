extends Control

@export var character_name_label: Label
@export var dialogue_text_label: Label
@export var dialogue: _Dialogue

# I hate this I hate this I hate this
# Should really make it in to a array but...
# Actually this should be done dynamically
# Can't overkill this
@export var character_sprite_1: TextureRect
@export var character_sprite_animation_player_1: AnimationPlayer

@export var character_sprite_2: TextureRect
@export var character_sprite_animation_player_2: AnimationPlayer

@export var character_sprite_texture: Array[Texture2D]

@export var text_box_animation_player: AnimationPlayer

# The current index of the dialogue sequance
var __current_dialogue_index: int = 0

# The position of character
# 0 is left and 1 and right
# There is no such a thing as pair so array will have to do
var __current_character_position: Array[_DialogueSequence.Characters] = [_DialogueSequence.Characters.NONE, _DialogueSequence.Characters.NONE]

func _ready() -> void:
	
	# Character enter -> text box slide in -> display line
	
	reset_dialogue_sequance()
	text_box_animation_player.play("slide_in")
	pass

func _gui_input(event: InputEvent) -> void:
	if ( (  event is not InputEventMouseButton) or not dialogue ):
		return
		
	if ( (event.button_index == MOUSE_BUTTON_LEFT) and event.pressed):
		# Can't do current_dialogue_index++ pain
		__current_dialogue_index += 1
		
		var keep_going: bool = await set_dialogue_sequence(__current_dialogue_index)
		
		if ( not keep_going ):
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
			await play_character_sprite_animation(character_position, "talk").animation_finished
			await get_tree().create_timer(0.25).timeout
		return true
	
	if(current_sequence is _CharacterSequence):
		set_character_sprite(current_sequence)
		await play_character_sprite_animation(current_sequence.character_position, "slide_in").animation_finished
		await get_tree().create_timer(0.5).timeout
		__current_dialogue_index += 1
		set_dialogue_sequence(__current_dialogue_index)
		return true

	return false

func play_character_sprite_animation(character_position: _DialogueSequence.Position, animation_name: String) -> AnimationPlayer:
	
	var target_animation_player: AnimationPlayer = null
	match(character_position):
		_DialogueSequence.Position.LEFT:
			target_animation_player = character_sprite_animation_player_1
			
		_DialogueSequence.Position.RIGHT:
			target_animation_player = character_sprite_animation_player_2
	target_animation_player.play(animation_name)
	return target_animation_player

## Set character sprite
func set_character_sprite(sequence: _CharacterSequence) -> void:
	
	var target_sprite: TextureRect = null

	match(sequence.character_position):
		_DialogueSequence.Position.LEFT:
			target_sprite = character_sprite_1
			__current_character_position[0] = sequence.character_name
			
		_DialogueSequence.Position.RIGHT:
			target_sprite = character_sprite_2
			__current_character_position[1] = sequence.character_name
			
	if( not target_sprite ):
		return
	
	## This is hardcoded to save time
	## It would be better to have a character class for storing sprite and their expression
	## Might actually do that later if needed
	## But for the purpose of testing and showcasing it works
	match(sequence.character_name):
		_DialogueSequence.Characters.DOKI:
			target_sprite.texture = character_sprite_texture[0]
		_DialogueSequence.Characters.DAD:
			target_sprite.texture = character_sprite_texture[1]
		_DialogueSequence.Characters.DRAGOON:
			target_sprite.texture = character_sprite_texture[2]
		_:
			target_sprite.texture = null
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
