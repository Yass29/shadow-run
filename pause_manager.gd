extends CanvasLayer

var overlay: Control
var hint: Label

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	layer = 100
	build_ui()

func build_ui() -> void:
	hint = Label.new()
	hint.text = "ESC  MENU"
	hint.position = Vector2(1020, 605)
	hint.add_theme_color_override("font_color", Color(0.55, 0.58, 0.72, 0.9))
	hint.add_theme_font_size_override("font_size", 12)
	add_child(hint)

	overlay = Control.new()
	overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	overlay.visible = false
	overlay.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(overlay)

	var dim := ColorRect.new()
	dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	dim.color = Color(0.01, 0.012, 0.035, 0.9)
	dim.mouse_filter = Control.MOUSE_FILTER_STOP
	overlay.add_child(dim)

	var card := ColorRect.new()
	card.position = Vector2(355, 120)
	card.size = Vector2(440, 410)
	card.color = Color(0.055, 0.06, 0.12, 0.99)
	overlay.add_child(card)

	var title := Label.new()
	title.position = Vector2(40, 42)
	title.size = Vector2(360, 48)
	title.text = "PAUSED"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 34)
	card.add_child(title)

	var resume := make_button("RESUME", 150)
	resume.pressed.connect(_resume)
	card.add_child(resume)

	var restart := make_button("RESTART LEVEL", 210)
	restart.pressed.connect(_restart)
	card.add_child(restart)

	var main := make_button("MAIN MENU", 270)
	main.pressed.connect(_main_menu)
	card.add_child(main)

	var quit := make_button("QUIT GAME", 330)
	quit.pressed.connect(_quit_game)
	card.add_child(quit)

func make_button(label: String, y: float) -> Button:
	var button := Button.new()
	button.position = Vector2(85, y)
	button.size = Vector2(270, 48)
	button.text = label
	button.process_mode = Node.PROCESS_MODE_ALWAYS
	return button

func _process(_delta: float) -> void:
	var scene := get_tree().current_scene
	var in_level := scene != null and scene.name.begins_with("Level")
	hint.visible = in_level and not overlay.visible

func _unhandled_input(event: InputEvent) -> void:
	if not (event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_ESCAPE):
		return
	var scene := get_tree().current_scene
	if scene == null or not scene.name.begins_with("Level"):
		return
	if overlay.visible:
		_resume()
	else:
		_pause()

func _pause() -> void:
	get_tree().paused = true
	overlay.visible = true

func _resume() -> void:
	overlay.visible = false
	get_tree().paused = false

func _restart() -> void:
	overlay.visible = false
	get_tree().paused = false
	get_tree().reload_current_scene()

func _main_menu() -> void:
	overlay.visible = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main_menu.tscn")

func _quit_game() -> void:
	get_tree().paused = false
	get_tree().quit()
