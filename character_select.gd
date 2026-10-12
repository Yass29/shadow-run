extends Control

@onready var status: Label = $Status

func _ready() -> void:
	$ShadeCard/Choose.pressed.connect(func(): choose("shade"))
	$NeonCard/Choose.pressed.connect(func(): choose("neon"))
	$WraithCard/Choose.pressed.connect(func(): choose("wraith"))
	$SpecterCard/Choose.pressed.connect(func(): choose("specter"))
	$Back.pressed.connect(_back)
	refresh()

func choose(skin_id: String) -> void:
	if GameState.select_skin(skin_id):
		status.text = "%s SELECTED" % GameState.SKINS[skin_id]["name"]
	else:
		var skin = GameState.SKINS[skin_id]
		status.text = "%s is premium (%s). Checkout will be connected when we publish." % [skin["name"], skin["price"]]
	refresh()

func refresh() -> void:
	$Current.text = "CURRENT: %s" % GameState.SKINS[GameState.selected_skin]["name"]
	$ShadeCard/Choose.text = "USE SHADE" if GameState.selected_skin != "shade" else "SELECTED"
	$NeonCard/Choose.text = "USE NEON" if GameState.selected_skin != "neon" else "SELECTED"
	$WraithCard/Choose.text = "PREMIUM  $2.99"
	$SpecterCard/Choose.text = "PREMIUM  $4.99"

func _back() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")
