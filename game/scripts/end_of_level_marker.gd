class_name _EndOfLevelMarker
extends Area2D

## Workaround for a Godot Engine bug:
## If this Area2D spawns too close to the main camera's EOL detector Area2D,
## only the latter will emit an 'area_entered' signal.
## (until the two Area2D moves far enough apart)
@export var new_checkpoint: Globals.Checkpoint = Globals.Checkpoint.MAINMENU
