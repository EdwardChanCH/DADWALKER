class_name _ScriptedSequence
extends Node2D

signal cutscene_finished

@export var camera_target: Node2D = null

## Entry point.
func enter_cutscene() -> void:
	pass

## Start dialogue sequence.
func start_dialogue() -> void:
	pass

## End dialogue sequence.
func end_dialogue() -> void:
	pass

## Start boss fight.
func start_fight() -> void:
	pass

## End boss fight.
func end_fight() -> void:
	pass
