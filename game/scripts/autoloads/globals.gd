class_name _Globals
extends Node
## Use this script for global functions and variables.
## Global variables should have getters & setters, and emit signals when changed.

# --- Constants --- #

enum HitboxLayer {
	WALL	,			# Layer 1
	PLAYER,			# Layer 2
	ENEMY,			# Layer 3
	BOSS	,			# Layer 4
	PLAYER_BULLET,	# Layer 5
	ENEMY_BULLET,	# Layer 6
	BOSS_BULLET,		# Layer 7
	LOADERS,			# Layer 8
}

enum Checkpoint {
	MAINMENU,
	INTRO_START,
	INTRO_END,
	MINI_BOSS_START,
	MINI_BOSS_FIGHT,
	MINI_BOSS_END,
	FINAL_BOSS_START,
	FINAL_BOSS_FIGHT,
	FINAL_BOSS_END,
	ENDING,
}

# --- Signals --- #

signal progress_updated(value: Checkpoint)

# --- Global Variables --- #

var god_mode: bool = false
var show_fps_count: bool = true
var text_display_speed: int = 50 # Letters per second.

var main_menu: _MainMenu = null
var setting_menu: _SettingMenu = null
var credit_menu: _CreditMenu = null
var dialogue_ui: _DialogueUI = null
var border_ui: _Border = null
var win_menu: _WinMenu = null
var lose_menu: _LoseMenu = null
var pause_menu: _PauseMenu = null

var gameplay: _Gameplay = null

var progress: Checkpoint = Checkpoint.MAINMENU :
	get:
		return progress
	set(value):
		progress = value
		progress_updated.emit(value)

# --- Math Functions --- #

const STEP: float = 0.00001 # Epsilon

## @GlobalScope.log() new implementation.
func logg(x: float, base: float) -> float:
	return log(x) / log(base)

## Find lerp weight t using exponential decay.
## [url]https://www.youtube.com/watch?v=LSNQuFEDOyQ[/url]
func lerp_t(decay: float, delta: float) -> float:
	return 1 - exp(-decay * delta)

# --- Misc. Functions --- #
