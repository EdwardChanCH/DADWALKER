class_name _Dialogue
extends Resource

enum Position
{
	NONE,
	LEFT,
	RIGHT
}

@export var character: Dictionary[_DialogueSequence.Characters, Position]

# Should have an event sequence for loading in sprites
@export var sequence: Array[_DialogueSequence]
