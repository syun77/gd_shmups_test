extends Area2D

class_name Player

const SHOT_OBJ = preload("res://src/shot/Shot.tscn")
const SHOT2_OBJ = preload("res://src/shot/Shot2.tscn")

const TIMER_BARRIER_HIT = 1.0
const TIMER_LASER = (0.016 * 16)
const TIMER_MOVE = 0.3
const TIMER_FORCE = 1.5
const TIMER_FORCE_INTERVAL = 3.0
const TIMER_FORCE_READY = 0.5

@onready var _spr = $Sprite

var _shot_timer = 0.0
var _shot_cnt = 0
var _laser_timer = 0.0
var _move_timer = 0.0
var _spr_base_sc = Vector2.ONE

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	
	_shot(delta)
	
	_update_anim(delta)
	
	var v = Vector2()
	if Input.is_action_pressed("ui_left"):
		v.x += -1
		_move_timer += delta * 3
	if Input.is_action_pressed("ui_up"):
		v.y += -1
	if Input.is_action_pressed("ui_right"):
		v.x += 1
		_move_timer += delta * 3
	if Input.is_action_pressed("ui_down"):
		v.y += 1
	
	v = v.normalized()
	var speed = 300
	if Input.is_action_pressed("ui_accept"):
		speed = 200
	position += speed * v * delta

func _shot(delta:float) -> void:
	_shot_timer -= delta
	
	if _laser_timer > 0:
		_shot_cnt += 1
		if _shot_cnt%2 == 0:
			_laser_timer -= delta
			_shot_laser()
		return
		
	if Input.is_action_just_pressed("ui_cancel"):
		# 力の解放.
		_laser_timer = TIMER_LASER
		_shot_laser()
		for i in range(3):
			Common.add_ring(position, 1.0 - (0.2*i), 128 + (4 * i), Color.WHITE)
		
		return
		
	if Input.is_action_pressed("ui_accept") == false:
		return
	if _shot_timer > 0:
		return
	if Common.get_layer("shot").get_child_count() > 8:
		return
	
	_shot_timer = 0.04
	_shot_cnt += 1
	for i in [-1, 0, 1]:
		var shot = SHOT_OBJ.instantiate()
		var pos = position
		pos.y -= 8
		pos += Vector2(8, 0) * i
		if _shot_cnt%2 == 0:
			pos.y -= 16
		var deg = 90 + randf_range(0, 10) * i * -1
		Common.get_layer("shot").add_child(shot)
		shot.setup(pos, deg, 1500)
		
func _shot_laser() -> void:
	var shot = SHOT2_OBJ.instantiate()
	Common.get_layer("shot").add_child(shot)
	shot.position = position
	var v = Vector2()
	var rad = deg_to_rad(270 + randf_range(-45, 45))
	var spd = randf_range(100, 1000)
	v.x = cos(rad) * spd
	v.y = -sin(rad) * spd
	shot.set_velocity(v)

func _update_anim(delta:float) -> void:
	if _move_timer > TIMER_MOVE:
		_move_timer = TIMER_MOVE
	_move_timer -= delta
	if _move_timer < 0.0:
		_move_timer = 0.0
	var rate = _move_timer / TIMER_MOVE
	var sc = _spr_base_sc.x - 0.5 * rate
	_spr.scale = Vector2(sc, _spr_base_sc.y)
