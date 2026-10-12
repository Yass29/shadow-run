extends Control

func _ready() -> void:
	$Card/Actions/MainMenu.pressed.connect(_on_main_menu)
	$Card/Actions/Replay.pressed.connect(_on_replay)
	$Card/Actions/NextLevel.pressed.connect(_on_next_level)

func show_victory(fragments: int, summary: Dictionary) -> void:
	GameState.unlock_level(2)
	$Card/Energy.text = "GRADE %s   •   %.1fs   •   %d deaths   •   ENERGY %d/3   •   ◆ %d" % [summary["grade"], float(summary["time"]), int(summary["deaths"]), fragments, GameState.shadow_shards]
	$Card/Perfect.visible = fragments >= 3
	visible = true
	$Card/Actions/Replay.grab_focus()

func _on_main_menu() -> void:
	ScreenTransition.change_scene("res://main_menu.tscn")

func _on_replay() -> void:
	get_tree().reload_current_scene()

func _on_next_level() -> void:
	ScreenTransition.change_scene("res://level2.tscn", "LEVEL 02", "LIGHT GRID")
