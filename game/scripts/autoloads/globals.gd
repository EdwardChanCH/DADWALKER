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
}

enum Checkpoint {
	MAINMENU,
	INTRO,
	MINI_BOSS,
	FINAL_BOSS,
	ENDING,
}

const SETTING_MENU_PATH: String = "res://scenes/ui/setting_menu.tscn"
const CREDIT_MENU_PATH: String = "res://scenes/ui/credit_menu.tscn"

# --- Signals --- #

signal progress_updated(value: Checkpoint)

# --- Global Variables --- #

var gameplay: _Gameplay = null

var player: _Player = null

var camera: _MainCamera = null

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
