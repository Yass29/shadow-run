extends Control

const LEVELS := [
	{"number": 1, "name": "ROOFTOP INITIATION", "scene": "res://level1.tscn", "accent": Color(0.52, 0.34, 0.88, 1.0)},
	{"number": 2, "name": "LIGHT GRID", "scene": "res://level2.tscn", "accent": Color(0.20, 0.76, 0.92, 1.0)},
	{"number": 3, "name": "RAIN DISTRICT", "scene": "res://level3.tscn", "accent": Color(0.30, 0.62, 0.95, 1.0)},
	{"number": 4, "name": "BLACKOUT TOWER", "scene": "res://level4.tscn", "accent": Color(0.64, 0.36, 0.92, 1.0)},
	{"number": 5, "name": "CORE RUN", "scene": "res://level5.tscn", "accent": Color(0.96, 0.30, 0.58, 1.0)}
]

@onready var list: VBoxContainer = $Panel/List

func _ready() -> void:
	$Back.pressed.connect(_back)
	build_levels()

func build_levels() -> void:
	for child in list.get_children():
		child.queue_free()

	for data in LEVELS:
		var row := Button.new()
		row.custom_minimum_size = Vector2(760, 64)
		var unlocked := int(data["number"]) <= GameState.max_unlocked_level
		row.disabled = not unlocked
		row.text = "LEVEL %02d   //   %s%s" % [
			int(data["number"]),
			str(data["name"]),
			"" if unlocked else "   [LOCKED]"
		]
		row.alignment = HORIZONTAL_ALIGNMENT_LEFT
		row.add_theme_font_size_override("font_size", 18)
		if unlocked:
			row.add_theme_color_override("font_color", data["accent"])
			var scene_path := str(data["scene"])
			row.pressed.connect(func(): get_tree().change_scene_to_file(scene_path))
		list.add_child(row)

func _back() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")
