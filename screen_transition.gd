extends CanvasLayer

var dim: ColorRect
var title: Label
var subtitle: Label
var busy := false

func _ready() -> void:
	layer = 200
	process_mode = Node.PROCESS_MODE_ALWAYS

	dim = ColorRect.new()
	dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	dim.color = Color(0.008, 0.01, 0.025, 0.0)
	dim.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(dim)

	title = Label.new()
	title.position = Vector2(120, 250)
	title.size = Vector2(910, 60)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 34)
	title.add_theme_color_override("font_color", Color(0.82, 0.9, 1.0, 1.0))
	title.modulate.a = 0.0
	add_child(title)

	subtitle = Label.new()
	subtitle.position = Vector2(120, 315)
	subtitle.size = Vector2(910, 38)
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.add_theme_font_size_override("font_size", 16)
	subtitle.add_theme_color_override("font_color", Color(0.62, 0.58, 0.9, 1.0))
	subtitle.modulate.a = 0.0
	add_child(subtitle)

func change_scene(path: String, heading: String = "", subheading: String = "") -> void:
	if busy:
		return
	busy = true
	title.text = heading
	subtitle.text = subheading

	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(dim, "color:a", 0.96, 0.24)
	tween.tween_property(title, "modulate:a", 1.0 if heading != "" else 0.0, 0.24)
	tween.tween_property(subtitle, "modulate:a", 1.0 if subheading != "" else 0.0, 0.24)
	await tween.finished

	await get_tree().create_timer(0.38, true).timeout
	get_tree().paused = false
	get_tree().change_scene_to_file(path)
	await get_tree().process_frame

	var out := create_tween()
	out.set_parallel(true)
	out.tween_property(dim, "color:a", 0.0, 0.34)
	out.tween_property(title, "modulate:a", 0.0, 0.22)
	out.tween_property(subtitle, "modulate:a", 0.0, 0.22)
	await out.finished
	busy = false
