class_name _MiniBossFight
extends _ScriptedSequence

signal mini_boss_dialogue_started
signal mini_boss_dialogue_ended
signal mini_boss_fight_started
signal mini_boss_fight_ended

@export var character_world: _DokibirdWorld = null
@export var boss_animation: AnimationPlayer = null
@export var boss_health: _BossHealth = null
@export var boss_hitbox_left: Area2D = null
@export var boss_hitbox_right: Area2D = null
@export var boss_shadow_left: Sprite2D = null
@export var boss_shadow_right: Sprite2D = null
@export var boss_sprite_left: Node2D = null
@export var boss_sprite_right: Node2D = null
@export var boss_timer: Timer = null
@export var projectile_spawner: _ProjectileSpawner = null
@export var enemy_spawner: _EnemySpawner = null

## Phases: 3 --> 2 --> 1 --> 0
var __boss_phase: int = 3

var __can_attack_again: bool = false

var __time_since_last_attack: float = 0

var __fight_ended: bool = false

## Left = true, Right = false.
var __is_on_left: bool = false

func _ready() -> void:
	super._ready()
	
	# Check if missing export variables.
	if (not character_world
		or not boss_animation
		or not boss_health
		or not boss_hitbox_left
		or not boss_hitbox_right
		or not boss_shadow_left
		or not boss_shadow_right
		or not boss_sprite_left
		or not boss_sprite_right
		or not boss_timer
		or not projectile_spawner
		or not enemy_spawner):
		push_error("Missing export variables in node '%s'." % [self.name])
	
	self.visible = true # TODO
	boss_sprite_left.visible = false
	boss_shadow_left.visible = false
	boss_hitbox_left.set_deferred("monitoring", false)
	boss_hitbox_left.set_deferred("monitorable", false)
	boss_hitbox_right.set_deferred("monitoring", false)
	boss_hitbox_right.set_deferred("monitorable", false)
	
	character_world.target_look_vector = Vector3.LEFT
	character_world.start_walk()
	pass

func _physics_process(delta: float) -> void:
	if (__fight_ended):
		return
	
	var percentage: float = boss_health.progress_bar.value
	
	if (percentage > 0.7):
		__boss_phase = 3
	elif (percentage > 0.3):
		__boss_phase = 2
	elif (percentage > 0):
		__boss_phase = 1
	else:
		__boss_phase = 0
	
	# --- Final Boss Logic --- #
	if __can_attack_again:
		__time_since_last_attack += delta
		
		if (__boss_phase == 0 and not __fight_ended):
			__fight_ended = true
			end_fight()
		elif __time_since_last_attack > 3:
			tomato_attack()
	pass

func exit_cutscene() -> void:
	if (Globals.gameplay):
		Globals.gameplay.queue_free_all_projectiles()
		Globals.gameplay.queue_free_all_game_objects()
		Globals.gameplay.main_camera.tracking_node = Globals.gameplay.player
	
	cutscene_finished.emit()
	pass

func enter_cutscene(_mode: int = 0) -> void:
	map_used_before = true
	self.visible = true
	boss_sprite_left.visible = false
	boss_shadow_left.visible = false
	character_world.target_look_vector = Vector3.LEFT
	
	if (Globals.gameplay):
		Globals.gameplay.player.restore_health()
		Globals.gameplay.main_camera.tracking_node = camera_target
		await Globals.gameplay.main_camera.target_reached
	
	if (_mode == 1):
		Globals.progress = Globals.Checkpoint.MINI_BOSS_FIGHT
		Globals.change_bgm("res://assets/sounds/bgm/bgm_dokiboss_fd1.ogg")
		start_fight()
	else:
		Globals.progress = Globals.Checkpoint.MINI_BOSS_START
		Globals.change_bgm("res://assets/sounds/bgm/bgm_gameplay_rd2.ogg")
		start_dialogue()
	pass

func start_dialogue() -> void:
	map_used_before = true
	
	mini_boss_dialogue_started.emit()
	
	Globals.border_ui.slide_in()
	await Globals.border_ui.slide_in_animation_finish
	
	Globals.dialogue_ui.start_dialgoue(Globals.dialogue_ui.dialogue_2)
	await Globals.dialogue_ui.finish_dialogue
	end_dialogue()
	pass

func end_dialogue() -> void:
	map_used_before = true
	
	Globals.border_ui.slide_out()
	await Globals.border_ui.slide_out_animation_finish
	
	mini_boss_dialogue_ended.emit()
	start_fight()
	pass

func start_fight() -> void:
	map_used_before = true
	Globals.progress = Globals.Checkpoint.MINI_BOSS_FIGHT
	Globals.change_bgm("res://assets/sounds/bgm/bgm_dokiboss_fd1.ogg")
	boss_sprite_left.visible = true
	boss_shadow_left.visible = true
	
	mini_boss_fight_started.emit()
	boss_hitbox_left.set_deferred("monitoring", false)
	boss_hitbox_left.set_deferred("monitorable", false)
	boss_hitbox_right.set_deferred("monitoring", true)
	boss_hitbox_right.set_deferred("monitorable", true)
	await boss_health.open_ui()
	__can_attack_again = true
	__fight_ended = false
	
	boss_timer.start(0.5)
	await boss_timer.timeout
	tomato_attack()
	pass

func end_fight() -> void:
	map_used_before = true
	
	# Move back to the right side.
	if (__is_on_left):
		character_world.target_look_vector = Vector3.LEFT
		boss_animation.play("boss_appear_right")
		await boss_animation.animation_finished
		__is_on_left = false
		boss_sprite_left.visible = false
		boss_shadow_left.visible = false
	
	character_world.start_death()
	
	mini_boss_fight_ended.emit()
	
	__can_attack_again = false
	boss_hitbox_left.set_deferred("monitoring", false)
	boss_hitbox_left.set_deferred("monitorable", false)
	boss_hitbox_right.set_deferred("monitoring", false)
	boss_hitbox_right.set_deferred("monitorable", false)

	await boss_health.close_ui()
	
	Globals.border_ui.slide_in()
	await Globals.border_ui.slide_in_animation_finish
	
	# Spawn a defeated tomato on Doki's body.
	enemy_spawner.global_position = boss_shadow_right.global_position
	enemy_spawner.direction = Vector2.RIGHT
	enemy_spawner.push_velocity = Vector2.ZERO
	var game_object: _GameObject = enemy_spawner.spawn_object()
	game_object.max_health = 10000
	game_object.current_health = 10000
	
	boss_timer.start(2)
	await boss_timer.timeout
	
	Globals.border_ui.slide_out()
	await Globals.border_ui.slide_out_animation_finish
	
	exit_cutscene()
	pass

func tomato_attack() -> void:
	__can_attack_again = false
	
	boss_hitbox_left.set_deferred("monitoring", true)
	boss_hitbox_left.set_deferred("monitorable", true)
	boss_hitbox_right.set_deferred("monitoring", true)
	boss_hitbox_right.set_deferred("monitorable", true)
	
	# Switch sides.
	if (__is_on_left):
		character_world.start_backflip(false)
		boss_animation.play("boss_appear_right")
		await boss_animation.animation_finished
		character_world.start_idle()
		#character_world.target_look_vector = Vector3.LEFT
		__is_on_left = false
	else:
		character_world.start_backflip(true)
		boss_animation.play("boss_appear_left")
		await boss_animation.animation_finished
		character_world.start_idle()
		#character_world.target_look_vector = Vector3.RIGHT
		__is_on_left = true
	
	if (__is_on_left):
		projectile_spawner.global_position = boss_sprite_left.global_position
		enemy_spawner.global_position = boss_sprite_left.global_position
		boss_hitbox_right.set_deferred("monitoring", false)
		boss_hitbox_right.set_deferred("monitorable", false)
	else:
		projectile_spawner.global_position = boss_sprite_right.global_position
		enemy_spawner.global_position = boss_sprite_right.global_position
		boss_hitbox_left.set_deferred("monitoring", false)
		boss_hitbox_left.set_deferred("monitorable", false)
	
	# Throw tomatoes.
	for i in range(-1, 2, 1):
		var direction: Vector2 = Vector2.RIGHT if __is_on_left else Vector2.LEFT
		direction = direction.rotated(deg_to_rad(i * 15)).normalized()
		# This audio has a bit of lag, so play it before of the timer starts.
		AudioManager.play_sfx("res://assets/sounds/sfx/sfx_ui_confirm_fd1.ogg", 0.5)
		character_world.target_look_vector = Vector3(direction.x, 0, direction.y)
		
		character_world.start_tomato()
		boss_timer.start(0.2)
		await boss_timer.timeout
		
		enemy_spawner.direction = direction
		# DO NOT CHANGE THIS VALUE,
		# OTHERWISE THE BOSS WILL HIT ITSELF IN CONFUSION.
		enemy_spawner.push_velocity = direction * 5000
		enemy_spawner.spawn_object()
	
	# Shoot bullets.
	for i in range(-1, 2, 1):
		var direction: Vector2 = Vector2.RIGHT if __is_on_left else Vector2.LEFT
		direction = direction.rotated(deg_to_rad(i * 17)).normalized()
		character_world.target_look_vector = Vector3(direction.x, 0, direction.y)
		
		character_world.start_bullet()
		boss_timer.start(0.1)
		await boss_timer.timeout
		
		projectile_spawner.shoot_once(direction)
		AudioManager.play_sfx("res://assets/sounds/sfx/sfx_npc_dokibirdattack_fd1.ogg", 0.2)
	
	character_world.start_idle()
	character_world.target_look_vector = Vector3.RIGHT if __is_on_left else Vector3.LEFT
	
	#boss_timer.start(0.5)
	#await boss_timer.timeout
	
	__can_attack_again = true
	__time_since_last_attack = 0
	pass

func _on_boss_hitbox_area_entered(area: Area2D) -> void:
	var game_object := area as _Projectile
	
	if (game_object is _Feather):
		boss_health.current_health -= 1
	elif (game_object is _Seed):
		boss_health.current_health -= 1000
		game_object.despawn()
	pass
