extends Control

func _ready() -> void:
	$Card/Actions/MainMenu.pressed.connect(_on_main_menu)
	$Card/Actions/Replay.pressed.connect(_on_replay)
	$Card/Actions/NextLevel.pressed.connect(_on_next_level)

func show_victory(fragments: int) -> void:
	$Card/Energy.text = "ENERGY RECOVERED   %d / 3" % fragments
	$Card/Perfect.visible = fragments >= 3
	visible = true
	$Card/Actions/Replay.grab_focus()

func _on_main_menu() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")

func _on_replay() -> void:
	get_tree().reload_current_scene()

func _on_next_level() -> void:
	$Card/ComingSoon.visible = true
