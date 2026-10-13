extends Control

const MEMORY_ORDER := ["M01", "M02", "M03", "M04", "M05", "M06"]

const MEMORY_META := {
	"M01": {"title": "INSIDE THE CORE", "level": "RAIN DISTRICT", "accent": Color(0.48, 0.78, 1.0, 1.0)},
	"M02": {"title": "HUNTER PROTOCOL", "level": "BLACKOUT TOWER", "accent": Color(0.72, 0.48, 1.0, 1.0)},
	"M03": {"title": "ERASED FIRST", "level": "CORE RUN", "accent": Color(1.0, 0.46, 0.72, 1.0)},
	"M04": {"title": "NO FEAR", "level": "MEMORY VAULT", "accent": Color(0.42, 0.92, 0.88, 1.0)},
	"M05": {"title": "THE SHADOW LEARNED", "level": "MEMORY VAULT", "accent": Color(0.64, 0.58, 1.0, 1.0)},
	"M06": {"title": "FINAL ORDER", "level": "MEMORY VAULT", "accent": Color(1.0, 0.58, 0.68, 1.0)}
}

func _ready() -> void:
	$Back.pressed.connect(_back)
	build_memories()
	refresh_reward()

func build_memories() -> void:
	var list: VBoxContainer = $Scroll/Panel/List
	for child in list.get_children():
		child.queue_free()

	for memory_id in MEMORY_ORDER:
		list.add_child(make_memory_card(memory_id))

	$Found.text = "%d / %d MEMORIES RECOVERED" % [GameState.unlocked_memories.size(), MEMORY_ORDER.size()]

func make_memory_card(memory_id: String) -> Control:
	var meta: Dictionary = MEMORY_META[memory_id]
	var unlocked := GameState.unlocked_memories.has(memory_id)
	var accent: Color = meta["accent"]

	var card := ColorRect.new()
	card.custom_minimum_size = Vector2(760, 104)
	card.color = Color(0.04, 0.045, 0.095, 1.0) if unlocked else Color(0.028, 0.032, 0.065, 1.0)

	var strip := ColorRect.new()
	strip.position = Vector2(0, 0)
	strip.size = Vector2(6, 104)
	strip.color = accent if unlocked else Color(0.16, 0.17, 0.24, 1.0)
	card.add_child(strip)

	var icon_bg := Polygon2D.new()
	icon_bg.position = Vector2(58, 52)
	icon_bg.polygon = PackedVector2Array([
		Vector2(0, -28), Vector2(20, -20), Vector2(28, 0), Vector2(20, 20),
		Vector2(0, 28), Vector2(-20, 20), Vector2(-28, 0), Vector2(-20, -20)
	])
	icon_bg.color = Color(accent.r, accent.g, accent.b, 0.22) if unlocked else Color(0.12, 0.13, 0.18, 1.0)
	card.add_child(icon_bg)

	var icon := Polygon2D.new()
	icon.position = Vector2(58, 52)
	icon.polygon = PackedVector2Array([Vector2(0, -14), Vector2(11, 0), Vector2(0, 14), Vector2(-11, 0)])
	icon.color = accent if unlocked else Color(0.30, 0.31, 0.38, 1.0)
	card.add_child(icon)

	var title := Label.new()
	title.position = Vector2(105, 12)
	title.size = Vector2(420, 26)
	title.add_theme_font_size_override("font_size", 17)
	title.add_theme_color_override("font_color", accent if unlocked else Color(0.46, 0.48, 0.60, 1.0))
	title.text = "%s   //   %s" % [memory_id, str(meta["title"]) if unlocked else "???"]
	card.add_child(title)

	var location := Label.new()
	location.position = Vector2(535, 12)
	location.size = Vector2(205, 24)
	location.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	location.add_theme_font_size_override("font_size", 11)
	location.add_theme_color_override("font_color", Color(0.44, 0.50, 0.62, 1.0))
	location.text = str(meta["level"]) if unlocked else "LOCATION UNKNOWN"
	card.add_child(location)

	var body := Label.new()
	body.position = Vector2(105, 46)
	body.size = Vector2(635, 48)
	body.add_theme_font_size_override("font_size", 13)
	body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	if unlocked:
		body.text = str(GameState.unlocked_memories[memory_id])
		body.add_theme_color_override("font_color", Color(0.74, 0.76, 0.88, 1.0))
	else:
		body.text = "Encrypted memory. Search the city in SHADOW form to recover it."
		body.add_theme_color_override("font_color", Color(0.34, 0.35, 0.46, 1.0))
	card.add_child(body)

	return card

func refresh_reward() -> void:
	var complete := GameState.unlocked_memories.size() >= MEMORY_ORDER.size()
	$Reward/Status.text = "UNLOCKED — ECHO SHADOW + 10 ◆" if complete else "RECOVER ALL 6 MEMORIES TO UNLOCK ECHO"
	$Reward/Status.add_theme_color_override(
		"font_color",
		Color(0.48, 1.0, 0.82, 1.0) if complete else Color(0.62, 0.58, 0.82, 1.0)
	)
	$Reward/Progress.text = "%d / 6" % GameState.unlocked_memories.size()

func _back() -> void:
	ScreenTransition.change_scene("res://main_menu.tscn")
