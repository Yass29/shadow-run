extends Control

const PANELS := [
	["THE NIGHT THE CORE BROKE", "At 02:17, every light in the city went out."],
	["YOUR SHADOW MOVED FIRST", "The Core took your memories. It couldn't take the thing that remembered for you."],
	["THE HUNT BEGAN", "Drones marked you. Hunters learned your footsteps. The shadow learned the rooftops."],
	["THE SHARDS ARE YOU", "Recover what was erased. Reach the Vault. Find out why they chose you."]
]

var index := 0
var animating := false

@onready var title: Label = $Title
@onready var text_label: Label = $StoryText
@onready var counter: Label = $Counter
@onready var scene: Node2D = $Scene
@onready var hero: Polygon2D = $Scene/Hero
@onready var shadow: Polygon2D = $Scene/Shadow
@onready var core: Polygon2D = $Scene/Core
@onready var drone: Node2D = $Scene/Drone
@onready var shard_a: Polygon2D = $Scene/ShardA
@onready var shard_b: Polygon2D = $Scene/ShardB
@onready var shard_c: Polygon2D = $Scene/ShardC
@onready var flash: ColorRect = $Flash
@onready var alarm: ColorRect = $AlarmBand

func _ready() -> void:
	$Next.pressed.connect(_next)
	$Skip.pressed.connect(_finish)
	show_panel(0)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		_next()
	elif event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_ESCAPE:
		_finish()

func show_panel(panel_index: int) -> void:
	if panel_index < 0 or panel_index >= PANELS.size():
		return
	index = panel_index
	title.text = PANELS[index][0]
	text_label.text = PANELS[index][1]
	counter.text = "%02d / %02d" % [index + 1, PANELS.size()]
	reset_scene()
	animate_panel()

func reset_scene() -> void:
	scene.position = Vector2.ZERO
	hero.position = Vector2(430, 365)
	hero.rotation = 0.0
	hero.modulate = Color.WHITE
	shadow.position = Vector2(430, 405)
	shadow.scale = Vector2(1.0, 0.30)
	shadow.modulate = Color(1, 1, 1, 0.55)
	core.position = Vector2(820, 285)
	core.scale = Vector2.ONE
	core.modulate = Color(1, 1, 1, 0.75)
	drone.position = Vector2(1080, 225)
	drone.modulate.a = 0.0
	for shard in [shard_a, shard_b, shard_c]:
		shard.position = Vector2(820, 285)
		shard.modulate.a = 0.0
		shard.scale = Vector2.ONE
	flash.color.a = 0.0
	alarm.color.a = 0.0
	title.modulate.a = 0.0
	text_label.modulate.a = 0.0

func animate_panel() -> void:
	animating = true
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(title, "modulate:a", 1.0, 0.28)
	tween.tween_property(text_label, "modulate:a", 1.0, 0.45)

	match index:
		0:
			tween.tween_property(core, "scale", Vector2(1.35, 1.35), 0.65)
			tween.tween_property(core, "modulate:a", 1.0, 0.30)
			tween.tween_property(alarm, "color:a", 0.22, 0.45)
			await tween.finished
			await core_break_flash()
		1:
			tween.tween_property(hero, "position:x", 510.0, 0.8)
			tween.tween_property(shadow, "position", Vector2(680, 402), 1.15)
			tween.tween_property(shadow, "scale", Vector2(1.7, 0.44), 1.15)
			await tween.finished
			AudioManager.play_sfx("shadow_in")
		2:
			drone.modulate.a = 1.0
			drone.position = Vector2(1120, 220)
			tween.tween_property(drone, "position:x", 530.0, 1.15)
			tween.tween_property(hero, "position:x", 650.0, 1.0)
			tween.tween_property(shadow, "position:x", 720.0, 1.0)
			tween.tween_property(alarm, "color:a", 0.18, 0.25)
			await tween.finished
			AudioManager.play_sfx("alert")
		3:
			tween.tween_property(core, "modulate:a", 0.18, 0.8)
			tween.tween_property(shard_a, "modulate:a", 1.0, 0.35)
			tween.tween_property(shard_b, "modulate:a", 1.0, 0.35)
			tween.tween_property(shard_c, "modulate:a", 1.0, 0.35)
			tween.tween_property(shard_a, "position", Vector2(600, 285), 0.9)
			tween.tween_property(shard_b, "position", Vector2(760, 360), 1.0)
			tween.tween_property(shard_c, "position", Vector2(935, 335), 1.1)
			await tween.finished
			AudioManager.play_sfx("shard")

	animating = false

func core_break_flash() -> void:
	flash.color.a = 0.72
	scene.position = Vector2(7, -3)
	AudioManager.play_sfx("alert")
	await get_tree().create_timer(0.06).timeout
	scene.position = Vector2(-6, 4)
	flash.color.a = 0.35
	await get_tree().create_timer(0.06).timeout
	scene.position = Vector2.ZERO
	flash.color.a = 0.0
	core.modulate.a = 0.22

func _next() -> void:
	if animating:
		return
	if index >= PANELS.size() - 1:
		_finish()
	else:
		show_panel(index + 1)

func _finish() -> void:
	GameState.intro_seen = true
	GameState.save_progress()
	ScreenTransition.change_scene("res://level1.tscn", "LEVEL 01", "ROOFTOP INITIATION")
