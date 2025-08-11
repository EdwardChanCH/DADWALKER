#TD: Added enter tree and exit tree animation
extends CanvasLayer

@export var close_button_animation_tree: AnimationTree

func _on_close_button_pressed() -> void:
	queue_free()
	pass


func _on_close_button_mouse_entered() -> void:
	close_button_animation_tree.set("parameters/Rotation/transition_request", "Hover") 
	pass 


func _on_close_button_mouse_exited() -> void:
	close_button_animation_tree.set("parameters/Rotation/transition_request", "Idle") 
	pass
