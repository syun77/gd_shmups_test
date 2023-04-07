extends Node2D
# =======================================
# メインシーン.
# =======================================

# ---------------------------------------
# preloads.
# ---------------------------------------

# ---------------------------------------
# consts.
# ---------------------------------------

# ---------------------------------------
# onready.
# ---------------------------------------
# Instances.
@onready var _player = $MainLayer/Player
# Layers
@onready var _bg_layer = $BgLayer
@onready var _main_layer = $MainLayer
@onready var _shot_layer = $ShotLayer
@onready var _bullet_layer = $BulletLayer
@onready var _particle_layer = $ParticleLayer

# ---------------------------------------
# vars.
# ---------------------------------------

# ---------------------------------------
# private functions.
# ---------------------------------------
func _ready() -> void:
	var layers = {
		"bg": _bg_layer,
		"main": _main_layer,
		"shot": _shot_layer,
		"bullet": _bullet_layer,
		"particle": _particle_layer,
	}
	Common.setup(layers, _player)

func _process(delta: float) -> void:
	pass
