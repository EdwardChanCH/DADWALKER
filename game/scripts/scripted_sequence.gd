class_name _ScriptedSequence
extends Node2D

signal cutscene_finished

@export var camera_target: Node2D = null

## True if a map may have despawned objects and need a reload.
var map_used_before: bool = false

func _ready() -> void:
	# Check if missing export variables.
	if (not camera_target):
		push_error("Missing export variables in node '%s'." % [self.name])
	
	map_used_before = false
	pass

## Entry point.
## Modes:
## 0 --- start at the beginning.
## 1 --- start at the boss fight if available, otherwise same as mode 0.
func enter_cutscene(_mode: int = 0) -> void:
	cutscene_finished.emit()
	pass

## Cleanup.
func exit_cutscene() -> void:
	cutscene_finished.emit()
	pass

## Start dialogue sequence.
func start_dialogue() -> void:
	cutscene_finished.emit()
	pass

## End dialogue sequence.
func end_dialogue() -> void:
	cutscene_finished.emit()
	pass

## Start boss fight.
func start_fight() -> void:
	cutscene_finished.emit()
	pass

## End boss fight.
func end_fight() -> void:
	cutscene_finished.emit()
	pass
