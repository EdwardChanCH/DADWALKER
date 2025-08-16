class_name _FinalBossFight
extends _ScriptedSequence

signal final_boss_dialogue_started
signal final_boss_dialogue_ended
signal final_boss_fight_started
signal final_boss_fight_ended

@export var character_world: _DadSkyWorld = null
@export var boss_animation: AnimationPlayer = null
@export var boss_health: _BossHealth = null
@export var boss_hitbox_area: Area2D = null
@export var ground_attack_area: Area2D = null
@export var boss_sprite: Node2D = null
@export var boss_timer: Timer = null
@export var projectile_spawner: _ProjectileSpawner = null
@export var enemy_spawner: _EnemySpawner = null
@export var enemy_spawner_l1: _EnemySpawner = null
@export var enemy_spawner_l2: _EnemySpawner = null
@export var enemy_spawner_l3: _EnemySpawner = null
@export var boss_sky_z_index: int = -6
@export var boss_ground_z_index: int = 6

## Phases: 3 --> 2 --> 1 --> 0
var __boss_phase: int = 3

## Patterns: 0 --> 1
var __attack_pattern: int = 0

var __can_attack_again: bool = false

var __time_since_last_attack: float = 0

var __fight_ended: bool = false

func _ready() -> void:
	super._ready()
	
	# Check if missing export variables.
	if (not character_world
		or not boss_animation
		or not boss_health
		or not boss_hitbox_area
		or not ground_attack_area
		or not boss_sprite
		or not boss_timer
		or not projectile_spawner
		or not enemy_spawner
		or not enemy_spawner_l1
		or not enemy_spawner_l2
		or not enemy_spawner_l3):
		push_error("Missing export variables in node '%s'." % [self.name])
	
	# Hide DAD.
	self.visible = false
	character_world.use_sky_camera()
	character_world.look_vector = Vector3.UP * 2 + Vector3.BACK * 0.01
	character_world.target_look_vector = Vector3.UP + Vector3.BACK * 0.01
	boss_hitbox_area.set_deferred("monitoring", false)
	boss_hitbox_area.set_deferred("monitorable", false)
	
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
		elif __time_since_last_attack > (1.0 * __boss_phase):
			match __attack_pattern:
				0:
					# Ground pound.
					ground_pound_attack()
					__attack_pattern = 1
				1:
					# Sonic boom left to middle, right to middle.
					sonic_boom_attack()
					__attack_pattern = 0
				_:
					# Should not occur.
					__attack_pattern = 0
	pass

func exit_cutscene() -> void:
	if (Globals.gameplay):
		Globals.gameplay.queue_free_all_projectiles()
		Globals.gameplay.queue_free_all_game_objects()
		Globals.gameplay.main_camera.tracking_node = Globals.gameplay.player
		Globals.gameplay.restore_sky()
	
	cutscene_finished.emit()
	pass

func enter_cutscene(_mode: int = 0) -> void:
	map_used_before = true
	
	self.visible = true
	
	if (Globals.gameplay):
		Globals.gameplay.player.restore_health()
		Globals.gameplay.main_camera.tracking_node = camera_target
		await Globals.gameplay.main_camera.target_reached
	
	if (_mode == 1):
		Globals.progress = Globals.Checkpoint.FINAL_BOSS_FIGHT
		Globals.change_bgm("res://assets/sounds/bgm/bgm_dadboss_fd3.ogg")
		start_fight()
	else:
		Globals.progress = Globals.Checkpoint.FINAL_BOSS_START
		Globals.change_bgm("res://assets/sounds/bgm/bgm_gameplay_rd2.ogg")
		start_dialogue()
	pass

func start_dialogue() -> void:
	map_used_before = true
	
	final_boss_dialogue_started.emit()
	print("fbf: start_dialogue") # TODO
	
	Globals.border_ui.slide_in()
	await Globals.border_ui.slide_in_animation_finish
	
	Globals.dialogue_ui.start_dialgoue(Globals.dialogue_ui.dialogue_3)
	await Globals.dialogue_ui.finish_dialogue
	end_dialogue()
	pass

func end_dialogue() -> void:
	map_used_before = true
	
	Globals.border_ui.slide_out()
	await Globals.border_ui.slide_out_animation_finish
	
	final_boss_dialogue_ended.emit()
	print("fbf: end_dialogue") # TODO
	start_fight()
	pass

func start_fight() -> void:
	map_used_before = true
	Globals.progress = Globals.Checkpoint.FINAL_BOSS_FIGHT
	Globals.change_bgm("res://assets/sounds/bgm/bgm_dadboss_fd3.ogg")
	
	final_boss_fight_started.emit()
	boss_hitbox_area.set_deferred("monitoring", true)
	boss_hitbox_area.set_deferred("monitorable", true)
	print("fbf: start_fight") # TODO
	if (Globals.gameplay):
		Globals.gameplay.main_camera.shake_camera()
		Globals.gameplay.destroy_sky()
	# TODO make buildings retract
	character_world.use_sky_camera()
	character_world.look_decay = 1
	character_world.target_look_vector = Vector3.BACK
	await boss_health.open_ui()
	boss_timer.start(3)
	await boss_timer.timeout
	character_world.look_decay = 8
	enemy_spawner.start_spawning()
	__can_attack_again = true
	__fight_ended = false
	pass

func end_fight() -> void:
	map_used_before = true
	
	final_boss_fight_ended.emit()
	__can_attack_again = false
	boss_hitbox_area.set_deferred("monitoring", false)
	boss_hitbox_area.set_deferred("monitorable", false)
	enemy_spawner.stop_spawning()
	print("fbf: end_fight") # TODO
	character_world.look_decay = 1
	# This could break if the boss is killed before the start_fight animation is finished.
	character_world.target_look_vector = Vector3.UP + Vector3.BACK * 0.01
	await boss_health.close_ui()
	character_world.look_decay = 8
	if (Globals.gameplay):
		Globals.gameplay.main_camera.shake_camera()
	
	boss_timer.start(1)
	await boss_timer.timeout
	
	# Prevent win screen if player died during the boss exit animation.
	if (not Globals.lose_menu.visible):
		Globals.progress = Globals.Checkpoint.FINAL_BOSS_END
		Globals.win_menu.visible = true
	
	exit_cutscene() # This line may have caused the tomato blackhole incident...
	pass

func ground_pound_attack() -> void:
	__can_attack_again = false
	
	boss_animation.play("sky_up")
	await boss_animation.animation_finished
	
	boss_hitbox_area.set_deferred("monitoring", false)
	boss_hitbox_area.set_deferred("monitorable", false)
	
	character_world.use_ground_camera()
	boss_sprite.z_index = boss_ground_z_index # In front of ground layer.
	
	boss_animation.play("ground_down")
	await boss_animation.animation_finished
	
	AudioManager.play_sfx("res://assets/sounds/sfx/sfx_npc_dadgroundstomp_fd1.ogg", 0.5)
	enemy_spawner_l1.spawn_object()
	enemy_spawner_l2.spawn_object()
	enemy_spawner_l3.spawn_object()
	
	if (Globals.gameplay):
		Globals.gameplay.main_camera.shake_camera()
	
	for node2d in ground_attack_area.get_overlapping_bodies():
		var player := node2d as _Player
		var basic_enemy := node2d as _BasicEnemy
		
		if (player):
			player.stomped()
		elif (basic_enemy):
			basic_enemy.stomped()
		pass
	
	boss_animation.play("ground_up")
	await boss_animation.animation_finished
	
	boss_hitbox_area.set_deferred("monitoring", true)
	boss_hitbox_area.set_deferred("monitorable", true)
	
	character_world.use_sky_camera()
	boss_sprite.z_index = boss_sky_z_index # Behind ground layer.
	
	boss_animation.play("sky_down")
	await boss_animation.animation_finished
	
	__can_attack_again = true
	__time_since_last_attack = 0
	pass

func sonic_boom_attack() -> void:
	await sonic_boom_attack_helper(Vector2(-1.5, 1), Vector2(0, 1))
	await sonic_boom_attack_helper(Vector2(1.5, 1), Vector2(0, 1))
	pass

func sonic_boom_attack_helper(from: Vector2, to: Vector2) -> void:
	__can_attack_again = false
	
	from = from.normalized()
	to = to.normalized()
	
	character_world.target_look_vector = Vector3(from.x, 0.3, from.y)
	
	boss_timer.start(0.5)
	await boss_timer.timeout
	
	AudioManager.play_sfx("res://assets/sounds/sfx/sfx_npc_dadsonicwave_fd1.ogg", 0.5)
	# Start spawning projectiles.
	for i in range(0, 11, 1):
		boss_timer.start(0.1)
		await boss_timer.timeout
		projectile_spawner.shoot_once(from.slerp(to, 0.1 * i))
	
	character_world.target_look_vector = Vector3.BACK
	
	boss_timer.start(0.5)
	await boss_timer.timeout
	
	__can_attack_again = true
	__time_since_last_attack = 0
	pass

func _on_boss_hitbox_area_entered(area: Area2D) -> void:
	var game_object := area as _Projectile
	
	if (game_object is _Feather):
		boss_health.current_health -= 1
	elif (game_object is _Seed):
		boss_health.current_health -= 10_000
		game_object.despawn()
	pass
