extends Control

const PANELS := [
	["THE NIGHT THE CORE BROKE", "The city lost its light. You lost something else."],
	["YOUR SHADOW STOOD UP", "It remembered routes, doors... and pieces of you."],
	["THE SHARDS ARE MEMORIES", "Every fragment carries something they tried to erase."],
	["RUN TO THE CORE", "Before the thing hunting you learns to wear your face."]
]

var index := 0
var animating := false

@onready var title: Label = $Title
@onready var text_label: Label = $StoryText
@onready var counter: Label = $Counter
@onready var hero: Polygon2D = $Scene/Hero
@onready var shadow: Polygon2D = $Scene/Shadow

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
	animate_panel()

func animate_panel() -> void:
	animating = true
	title.modulate.a = 0.0
	text_label.modulate.a = 0.0

	hero.position = Vector2(380, 350)
	shadow.position = Vector2(380, 388)
	shadow.scale = Vector2(1.0, 0.34)

	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(title, "modulate:a", 1.0, 0.35)
	tween.tween_property(text_label, "modulate:a", 1.0, 0.55)
	tween.tween_property(hero, "position:x", 500.0 + index * 12.0, 0.9)
	tween.tween_property(shadow, "position:x", 610.0 + index * 34.0, 1.15)
	tween.tween_property(shadow, "scale", Vector2(1.45, 0.45), 1.15)
	await tween.finished
	animating = false

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
