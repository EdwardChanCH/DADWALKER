class_name _CreditMenu
extends CanvasLayer

@export var close_button_animation_tree: AnimationTree

func _ready() -> void:
	visible = false
	Globals.credit_menu = self
	pass

func _on_close_button_pressed() -> void:
	visible = false
	pass


func _on_close_button_mouse_entered() -> void:
	close_button_animation_tree.set("parameters/Rotation/transition_request", "Hover") 
	pass 


func _on_close_button_mouse_exited() -> void:
	close_button_animation_tree.set("parameters/Rotation/transition_request", "Idle") 
	pass
