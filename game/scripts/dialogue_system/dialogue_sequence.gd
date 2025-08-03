class_name _DialogueSequence
extends Resource

# I rather use string but to make this easier to use enum it is
enum Characters
{
	NONE,
	DOKI,
	DAD,
	DRAGOON
}

@export var character_name: Characters = Characters.NONE
@export var sequence_text: String = "Empty Text"
