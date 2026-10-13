extends Control

const PANELS := [
	["THE VAULT OPENS", "The memories were never destroyed. They were waiting for you."],
	["THE SHADOW RETURNS", "It was never another creature. It was the part of you that refused to disappear."],
	["THE CITY WAKES", "One Core is silent. Five districts remember your name."],
	["RUN AGAIN", "There are still locked memories, faster routes, and perfect runs left in the dark."]
]

var index := 0
var animating := false

@onready var title: Label = $Title
@onready var text_label: Label = $StoryText
@onready var counter: Label = $Counter
@onready var hero: Polygon2D = $Scene/Hero
@onready var shadow: Polygon2D = $Scene/Shadow
@onready var core: Polygon2D = $Scene/Core
@onready var scene: Node2D = $Scene

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
	reset_scene()
	animate_panel()

func reset_scene() -> void:
	scene.position = Vector2.ZERO
	hero.position = Vector2(440, 355)
	hero.scale = Vector2.ONE
	shadow.position = Vector2(520, 390)
	shadow.scale = Vector2(1.35, 0.38)
	shadow.modulate.a = 0.62
	core.position = Vector2(720, 330)
	core.scale = Vector2.ONE
	core.modulate.a = 0.90
	title.modulate.a = 0.0
	text_label.modulate.a = 0.0

func animate_panel() -> void:
	animating = true
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(title, "modulate:a", 1.0, 0.30)
	tween.tween_property(text_label, "modulate:a", 1.0, 0.45)

	match index:
		0:
			tween.tween_property(core, "scale", Vector2(0.18, 0.18), 1.0)
			tween.tween_property(core, "modulate:a", 0.08, 1.0)
			await tween.finished
			AudioManager.play_sfx("victory")
		1:
			tween.tween_property(shadow, "position", Vector2(445, 385), 1.1)
			tween.tween_property(shadow, "scale", Vector2(0.65, 0.24), 1.1)
			tween.tween_property(shadow, "modulate:a", 0.18, 1.1)
			tween.tween_property(hero, "scale", Vector2(1.08, 1.08), 1.1)
			await tween.finished
			AudioManager.play_sfx("shadow_out")
		2:
			tween.tween_property(scene, "position:y", -18.0, 1.0)
			tween.tween_property(core, "modulate:a", 0.0, 0.6)
			await tween.finished
		3:
			tween.tween_property(hero, "position:x", 610.0, 1.0)
			tween.tween_property(shadow, "position:x", 665.0, 1.0)
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
