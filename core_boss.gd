extends Node2D

@export var arena_left := 3300.0
@export var arena_right := 3690.0
@export var scan_interval := 2.8
@export var warning_duration := 0.75

var active := false
var defeated := false
var hits := 0
var scan_timer := 1.6
var warning_timer := 0.0
var warning_active := false
var point_a_used := false
var point_b_used := false

@onready var player: CharacterBody2D = get_parent().get_node("Player")
@onready var scan_visual: Polygon2D = $ScanVisual
@onready var core: Polygon2D = $Core
@onready var point_a: Area2D = $WeakPointA
@onready var point_b: Area2D = $WeakPointB

func _ready() -> void:
	scan_visual.visible = false
	point_a.body_entered.connect(_on_weak_point_a)
	point_b.body_entered.connect(_on_weak_point_b)

func _process(delta: float) -> void:
	if defeated or player == null:
		return

	if not active:
		if player.global_position.x >= arena_left:
			active = true
			var level := get_parent()
			if level.has_method("start_boss_encounter"):
				level.start_boss_encounter()
		else:
			scan_timer = 1.0
		return

	if warning_active:
		warning_timer -= delta
		var pulse := 0.16 + (sin(Time.get_ticks_msec() * 0.03) + 1.0) * 0.10
		scan_visual.modulate.a = pulse
		if warning_timer <= 0.0:
			fire_scan()
		return

	scan_timer -= delta
	if scan_timer <= 0.0:
		start_warning()

func start_warning() -> void:
	warning_active = true
	warning_timer = warning_duration
	scan_visual.visible = true
	scan_visual.modulate.a = 0.18

func fire_scan() -> void:
	warning_active = false
	scan_timer = scan_interval
	scan_visual.modulate.a = 0.55
	AudioManager.play_sfx("alert")

	if player.global_position.x >= arena_left and player.global_position.x <= arena_right and not bool(player.get("is_shadow")):
		var level := get_parent()
		if level.has_method("respawn_player"):
			level.respawn_player("CORE SCAN — disappear into shadow.")

	var tween := create_tween()
	tween.tween_property(scan_visual, "modulate:a", 0.0, 0.22)
	tween.tween_callback(func(): scan_visual.visible = false)

func _on_weak_point_a(body: Node) -> void:
	if point_a_used:
		return
	if body is CharacterBody2D and bool(body.get("is_shadow")):
		point_a_used = true
		disable_point(point_a)
		register_hit()

func _on_weak_point_b(body: Node) -> void:
	if point_b_used:
		return
	if body is CharacterBody2D and bool(body.get("is_shadow")):
		point_b_used = true
		disable_point(point_b)
		register_hit()

func disable_point(point: Area2D) -> void:
	point.monitoring = false
	point.modulate = Color(0.35, 1.0, 0.82, 0.35)
	AudioManager.play_sfx("checkpoint")

func register_hit() -> void:
	hits += 1
	core.modulate = Color(1.0, 0.45 + hits * 0.18, 0.65, 1.0)
	var level := get_parent()
	if level.has_method("boss_hit"):
		level.boss_hit(hits)

	if hits >= 2:
		defeat()

func defeat() -> void:
	defeated = true
	scan_visual.visible = false
	AudioManager.play_sfx("victory")
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(core, "scale", Vector2(0.25, 0.25), 0.5)
	tween.tween_property(core, "modulate:a", 0.0, 0.5)
	await tween.finished

	var level := get_parent()
	if level.has_method("boss_defeated"):
		level.boss_defeated()
