extends Control

@onready var status: Label = $Status

func _ready() -> void:
	$Shade.pressed.connect(func(): choose("shade"))
	$Neon.pressed.connect(func(): choose("neon"))
	$Wraith.pressed.connect(func(): choose("wraith"))
	$Specter.pressed.connect(func(): choose("specter"))
	$Back.pressed.connect(_back)
	refresh()

func choose(skin_id: String) -> void:
	if GameState.select_skin(skin_id):
		status.text = "%s SELECTED" % GameState.SKINS[skin_id]["name"]
	else:
		var skin = GameState.SKINS[skin_id]
		status.text = "%s is a premium skin (%s). Store checkout coming next." % [skin["name"], skin["price"]]
	refresh()

func refresh() -> void:
	$Current.text = "CURRENT: %s" % GameState.SKINS[GameState.selected_skin]["name"]
	$Wraith.text = "WRAITH  •  PREMIUM $2.99"
	$Specter.text = "SPECTER  •  PREMIUM $4.99"

func _back() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")
