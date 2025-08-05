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
var current_dialogue_index: int = 0

func _ready() -> void:
	text_box_animation_player.play("slide_in")
	reset_dialogue_sequance()
	pass

func _gui_input(event: InputEvent) -> void:
	if ( (  event is not InputEventMouseButton) or not dialogue ):
		return
		
	if ( (event.button_index == MOUSE_BUTTON_LEFT) and event.pressed):
		# Can't do current_dialogue_index++ pain
		current_dialogue_index += 1
		if ( not set_dialogue_sequence(current_dialogue_index) ):
			visible = false
		print("Clicked")
		
	pass

## Set the current sequence of dialogue to the start
func reset_dialogue_sequance() -> void:
	set_dialogue_sequence(0);
	pass

## Set the current sequence of dialogue
func set_dialogue_sequence(set_dialogue_sequence_text: int) -> bool:
	
	# Check if the sequence is valid
	if ( dialogue.sequence.size() - 1 < set_dialogue_sequence_text ):
		return false
	
	# Set text and name of the sequence
	var sequence = dialogue.sequence[set_dialogue_sequence_text]
	var character_name = _DialogueSequence.Characters.find_key(sequence.character_name)
	
	dialogue_text_label.text = sequence.sequence_text
	character_name_label.text = character_name.capitalize()
	
	# Set sprite of the sequence	
	var postion : _Dialogue.Position = dialogue.character[sequence.character_name]
	set_character_sprite(sequence.character_name, postion)
	
	match (postion):
		_Dialogue.Position.LEFT:
			character_sprite_1.modulate = Color(1, 1, 1)
			character_sprite_2.modulate = Color(0.5, 0.5, 0.5)
		_Dialogue.Position.RIGHT:
			character_sprite_1.modulate = Color(0.5, 0.5, 0.5)
			character_sprite_2.modulate = Color(1, 1, 1)
		_:
			character_sprite_1.modulate = Color(0.5, 0.5, 0.5)
			character_sprite_2.modulate = Color(0.5, 0.5, 0.5)
	
	return true

## Set character sprite
func set_character_sprite(character: _DialogueSequence.Characters, position: _Dialogue.Position) -> void:
	
	var target_sprite: TextureRect = null
	var target_animation_player: AnimationPlayer = null
	
	match(position):
		_Dialogue.Position.LEFT:
			target_sprite = character_sprite_1
			target_animation_player = character_sprite_animation_player_1
			
		_Dialogue.Position.RIGHT:
			target_sprite = character_sprite_2
			target_animation_player = character_sprite_animation_player_2
			
	if( not target_sprite ):
		return
	
	# This is hardcoded to save time
	# It would be better to have a character class for storing sprite and their expression
	# Might actually do that later if needed
	# But for the purpose of testing and showcasing it works
	match(character):
		_DialogueSequence.Characters.DOKI:
			target_sprite.texture = character_sprite_texture[0]
			
		_DialogueSequence.Characters.DAD:
			target_sprite.texture = character_sprite_texture[1]
			
		_DialogueSequence.Characters.DRAGOON:
			target_sprite.texture = character_sprite_texture[2]
			
	target_animation_player.play("slide_in")
	
	pass
