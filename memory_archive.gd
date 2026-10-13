extends Control

const MEMORY_ORDER := ["M01", "M02", "M03", "M04", "M05", "M06"]

func _ready() -> void:
	$Back.pressed.connect(_back)
	build_memories()

func build_memories() -> void:
	var list: VBoxContainer = $Scroll/Panel/List
	for child in list.get_children():
		child.queue_free()

	for memory_id in MEMORY_ORDER:
		var card := ColorRect.new()
		card.custom_minimum_size = Vector2(760, 74)
		card.color = Color(0.045, 0.05, 0.10, 1.0)

		var title := Label.new()
		title.position = Vector2(18, 10)
		title.size = Vector2(210, 26)
		title.add_theme_font_size_override("font_size", 17)
		title.add_theme_color_override("font_color", Color(0.72, 0.82, 1.0, 1.0))
		title.text = memory_id
		card.add_child(title)

		var body := Label.new()
		body.position = Vector2(18, 36)
		body.size = Vector2(720, 28)
		body.add_theme_font_size_override("font_size", 14)
		if GameState.unlocked_memories.has(memory_id):
			body.text = str(GameState.unlocked_memories[memory_id])
			body.add_theme_color_override("font_color", Color(0.72, 0.72, 0.86, 1.0))
		else:
			body.text = "LOCKED — find this memory in the city."
			body.add_theme_color_override("font_color", Color(0.36, 0.38, 0.50, 1.0))
		card.add_child(body)

		list.add_child(card)

	$Found.text = "%d / %d MEMORIES RECOVERED" % [GameState.unlocked_memories.size(), MEMORY_ORDER.size()]

func _back() -> void:
	ScreenTransition.change_scene("res://main_menu.tscn")
