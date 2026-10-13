extends Control

const PANELS := [
	["THE CORE FALLS SILENT", "For the first time, your shadow stops running."],
	["IT WAS NEVER THE MONSTER", "It was the part of you the Core cut away to make you obedient."],
	["MEMORY RETURNS IN PIECES", "The shards were not fuel. They were your stolen memories."],
	["BUT FOUR CORES STILL BURN", "Tonight you survived. Tomorrow, the city learns your name."]
]

var index := 0
var animating := false

@onready var title: Label = $Title
@onready var text_label: Label = $StoryText
@onready var counter: Label = $Counter
@onready var hero: Polygon2D = $Scene/Hero
@onready var shadow: Polygon2D = $Scene/Shadow
@onready var core: Polygon2D = $Scene/Core

func _ready() -> void:
	GameState.ending_seen = true
	GameState.save_progress()
	$Next.pressed.connect(_next)
	$Menu.pressed.connect(_menu)
	show_panel(0)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		_next()
	elif event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_ESCAPE:
		_menu()

func show_panel(panel_index: int) -> void:
	index = panel_index
	title.text = PANELS[index][0]
	text_label.text = PANELS[index][1]
	counter.text = "%02d / %02d" % [index + 1, PANELS.size()]
	animate_panel()

func animate_panel() -> void:
	animating = true
	title.modulate.a = 0.0
	text_label.modulate.a = 0.0
	core.scale = Vector2.ONE
	core.modulate.a = 0.9
	hero.position = Vector2(440, 355)
	shadow.position = Vector2(520, 390)

	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(title, "modulate:a", 1.0, 0.35)
	tween.tween_property(text_label, "modulate:a", 1.0, 0.5)
	tween.tween_property(core, "scale", Vector2(0.55, 0.55), 1.0)
	tween.tween_property(core, "modulate:a", 0.25, 1.0)
	tween.tween_property(shadow, "position:x", 470.0, 1.0)
	await tween.finished
	animating = false

func _next() -> void:
	if animating:
		return
	if index >= PANELS.size() - 1:
		_menu()
	else:
		show_panel(index + 1)

func _menu() -> void:
	ScreenTransition.change_scene("res://main_menu.tscn", "SHADOW RUN", "THE CITY REMEMBERS.")
