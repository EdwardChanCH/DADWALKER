class_name _CreditMenu
extends CanvasLayer

@export var close_button_animation_tree: AnimationTree
@export var animation_player: AnimationPlayer

func _ready() -> void:
	visible = false
	Globals.credit_menu = self
	visibility_changed.connect(_play_slide_in_animation)
	pass

func _play_slide_in_animation() -> void:
	if (visible):
		animation_player.play("slide_in")
	pass

func _on_close_button_pressed() -> void:
	animation_player.play("slide_out")
	await animation_player.animation_finished
	visible = false
	pass


func _on_close_button_mouse_entered() -> void:
	close_button_animation_tree.set("parameters/Rotation/transition_request", "Hover") 
	pass 


func _on_close_button_mouse_exited() -> void:
	close_button_animation_tree.set("parameters/Rotation/transition_request", "Idle") 
	pass
