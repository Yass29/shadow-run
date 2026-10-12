extends Control

const PREVIEW_SCRIPT = preload("res://skin_preview.gd")

@onready var grid: GridContainer = $Scroll/Grid
@onready var shards_label: Label = $Shards
@onready var current_label: Label = $Current
@onready var status: Label = $Status

func _ready() -> void:
	$Back.pressed.connect(_back)
	build_cards()
	refresh_header()

func build_cards() -> void:
	for child in grid.get_children():
		child.queue_free()

	for skin_id in GameState.SKIN_ORDER:
		grid.add_child(make_card(skin_id))

func make_card(skin_id: String) -> Control:
	var skin = GameState.SKINS[skin_id]

	var card := ColorRect.new()
	card.custom_minimum_size = Vector2(235, 300)
	card.color = Color(0.055, 0.06, 0.12, 1.0)

	var preview := Control.new()
	preview.set_script(PREVIEW_SCRIPT)
	preview.set("skin_id", skin_id)
	preview.position = Vector2(22, 14)
	preview.size = Vector2(190, 150)
	card.add_child(preview)

	var name_label := Label.new()
	name_label.position = Vector2(12, 165)
	name_label.size = Vector2(211, 30)
	name_label.text = str(skin["name"])
	name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	name_label.add_theme_font_size_override("font_size", 20)
	card.add_child(name_label)

	var type_label := Label.new()
	type_label.position = Vector2(12, 198)
	type_label.size = Vector2(211, 25)
	type_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

	if bool(skin["premium"]):
		type_label.text = "PREMIUM  %s" % skin["price"]
		type_label.add_theme_color_override("font_color", Color(0.95, 0.62, 1.0, 1.0))
	elif int(skin["cost"]) > 0:
		type_label.text = "%d SHARDS" % int(skin["cost"])
		type_label.add_theme_color_override("font_color", Color(0.55, 0.9, 1.0, 1.0))
	else:
		type_label.text = "FREE"
		type_label.add_theme_color_override("font_color", Color(0.5, 1.0, 0.85, 1.0))
	card.add_child(type_label)

	var button := Button.new()
	button.position = Vector2(18, 238)
	button.size = Vector2(199, 46)
	button.name = "Choose"
	button.pressed.connect(func(): choose(skin_id))
	card.add_child(button)

	if GameState.selected_skin == skin_id:
		button.text = "SELECTED"
	elif GameState.is_owned(skin_id):
		button.text = "USE %s" % skin["name"]
	elif bool(skin["premium"]):
		button.text = "PREMIUM  %s" % skin["price"]
	else:
		button.text = "UNLOCK  %d ◆" % int(skin["cost"])

	return card

func choose(skin_id: String) -> void:
	var skin = GameState.SKINS[skin_id]

	if GameState.is_owned(skin_id):
		GameState.select_skin(skin_id)
		status.text = "%s SELECTED" % skin["name"]
	elif bool(skin["premium"]):
		status.text = "%s is premium (%s). Real checkout comes with the web release." % [skin["name"], skin["price"]]
	else:
		var cost := int(skin["cost"])
		if GameState.purchase_skin(skin_id):
			GameState.select_skin(skin_id)
			status.text = "%s UNLOCKED!" % skin["name"]
		else:
			status.text = "Need %d shards. You have %d." % [cost, GameState.shadow_shards]

	build_cards()
	refresh_header()

func refresh_header() -> void:
	shards_label.text = "◆  %d SHADOW SHARDS" % GameState.shadow_shards
	current_label.text = "CURRENT: %s" % GameState.SKINS[GameState.selected_skin]["name"]

func _back() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")
