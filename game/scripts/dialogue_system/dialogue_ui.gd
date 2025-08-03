extends Control

@export var character_name_label: Label
@export var dialogue_text_label: Label
@export var dialogue: _Dialogue

# The current index of the dialogue sequance
var current_dialogue_index: int = 0

func _ready() -> void:
	if(character_name_label or dialogue_text_label):
		reset_dialogue_text()
		return
	printerr("Label not set")
	pass

func _gui_input(event: InputEvent) -> void:
	if ( (  event is not InputEventMouseButton) or not dialogue ):
		return
		
	if ( (event.button_index == MOUSE_BUTTON_LEFT) and event.pressed):
		# Can't do current_dialogue_index++ pain
		current_dialogue_index += 1
		if ( not set_dialogue_sequence_text(current_dialogue_index) ):
			visible = false
		print("Clicked")
		
	pass



func reset_dialogue_text() -> void:
	set_dialogue_sequence_text(0);
	pass

func set_dialogue_sequence_text(set_dialogue_sequence_text: int) -> bool:
	if ( dialogue.sequence.size() - 1 < set_dialogue_sequence_text ):
		return false
		
	dialogue_text_label.text = dialogue.sequence[set_dialogue_sequence_text].Text
	var name = _DialogueSequence.Characters.find_key(dialogue.sequence[set_dialogue_sequence_text].CharacterName)
	character_name_label.text = name.capitalize()
	return true
