extends Control

@export var character_name_label: Label
@export var dialogue_text_label: Label

@export var dialogue: _Dialogue 
var current_dialogue_index: int = 0

func _ready() -> void:
	if(character_name_label or dialogue_text_label):
		reset_dialogue_text()
		return
	printerr("Label not set")
	pass

func _gui_input(event: InputEvent) -> void:
	if ( ( event is not InputEventMouseButton ) or not dialogue ):
		return
		
	if ( event.button_index == MOUSE_BUTTON_LEFT and event.pressed):
		if ( dialogue.sequeance.size() - 1 > current_dialogue_index ):
			current_dialogue_index += 1
			dialogue_text_label.text = dialogue.sequeance[current_dialogue_index].Text
			
			var name: String = _DialogueSequeance.Characters.find_key(dialogue.sequeance[current_dialogue_index].CharacterName)
			character_name_label.text = name.capitalize()
			
			
		else:
			visible = false
		print("Clicked")
		
		
	pass

func reset_dialogue_text() -> void:
	current_dialogue_index = 0
	dialogue_text_label.text = dialogue.sequeance[0].Text
	var name = _DialogueSequeance.Characters.find_key(dialogue.sequeance[current_dialogue_index].CharacterName)
	character_name_label.text = name.capitalize()
	
	pass
