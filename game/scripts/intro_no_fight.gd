class_name _IntroNoFight
extends _ScriptedSequence

signal intro_dialogue_started
signal intro_dialogue_ended

@export var animation_player: AnimationPlayer = null
@export var boss_timer: Timer = null
@export var dad: _DadWorld = null
@export var doki: _DokibirdWorld = null
@export var tomato: _TomatoWorld = null
@export var leash: Line2D = null

@export var leash_holder_1: Node2D = null
@export var leash_holder_2: Node2D = null
var leash_holder_3: Node2D = null

var render_leash: bool = false

func _ready() -> void:
	super._ready()
	
	# Check if missing export variables.
	if (false):
		push_error("Missing export variables in node '%s'." % [self.name])
	
	self.visible = false
	
	tomato.target_look_vector = Vector3.LEFT
	doki.target_look_vector = Vector3.LEFT
	pass

func _physics_process(delta: float) -> void:
	if (render_leash and leash_holder_1 and leash_holder_2):
		leash.visible = true
		leash.clear_points()
		leash.clear_points()
		leash.add_point(leash_holder_1.global_position - leash.global_position)
		leash.add_point(leash_holder_2.global_position - leash.global_position)
	pass

func exit_cutscene() -> void:
	render_leash = false
	
	if (Globals.gameplay):
		Globals.gameplay.queue_free_all_projectiles()
		Globals.gameplay.queue_free_all_game_objects()
		Globals.gameplay.main_camera.tracking_node = Globals.gameplay.player
	
	cutscene_finished.emit()
	pass

func enter_cutscene(_mode: int = 0) -> void:
	render_leash = true
	leash.visible = true
	
	map_used_before = true
	Globals.progress = Globals.Checkpoint.INTRO_START
	Globals.change_bgm("res://assets/sounds/bgm/bgm_gameplay_rd2.ogg")
	
	self.visible = true
	
	if (Globals.gameplay):
		Globals.gameplay.player.restore_health()
		Globals.gameplay.main_camera.tracking_node = camera_target
		await Globals.gameplay.main_camera.target_reached
	
	start_dialogue()
	pass

func start_dialogue() -> void:
	map_used_before = true
	
	leash_holder_3 = Globals.gameplay.player.leash_dragoon
	
	intro_dialogue_started.emit()
	
	Globals.border_ui.slide_in()
	await Globals.border_ui.slide_in_animation_finish
	
	Globals.dialogue_ui.start_dialgoue(Globals.dialogue_ui.dialogue_1)
	await Globals.dialogue_ui.finish_dialogue
	
	end_dialogue()
	pass

func end_dialogue() -> void:
	map_used_before = true
	
	if (animation_player.current_animation == "intro"):
		animation_player.stop()
	animation_player.play("intro")
	
	doki.target_look_vector = Vector3.RIGHT
	leash_holder_2 = leash_holder_3
	
	boss_timer.start(0.7)
	await boss_timer.timeout
	# DAD starts rolling.
	dad.start_rolling()
	
	boss_timer.start(1.3)
	await boss_timer.timeout
	# DAD stops rolling.
	dad.stop_rolling()
	
	boss_timer.start(1)
	await boss_timer.timeout
	# Tomato turns right.
	tomato.target_look_vector = Vector3.RIGHT
	
	boss_timer.start(0.3)
	await boss_timer.timeout
	# DAD starts rolling fast.
	dad.start_rolling_fast()
	
	boss_timer.start(0.2)
	await boss_timer.timeout
	# Rope snaps?
	AudioManager.play_sfx("res://assets/sounds/sfx/sfx_npc_enemyattack_fd1.ogg", 0.3)
	render_leash = false
	leash.visible = false
	
	boss_timer.start(0.2)
	await boss_timer.timeout
	
	Globals.border_ui.slide_out()
	await Globals.border_ui.slide_out_animation_finish
	
	intro_dialogue_ended.emit()
	
	Globals.progress = Globals.Checkpoint.INTRO_END
	Globals.gameplay.change_map_to(Globals.Checkpoint.INTRO_END)
	
	exit_cutscene()
	pass
