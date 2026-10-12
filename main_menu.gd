extends Control

func _ready() -> void:
	$PlayButton.text = "CONTINUE LEVEL %02d" % GameState.max_unlocked_level
	$PlayButton.grab_focus()
	$ShardCounter.text = "◆ %d SHARDS" % GameState.shadow_shards
	$Progress.text = "LEVELS UNLOCKED  %d / 5" % GameState.max_unlocked_level

func _on_play_pressed() -> void:
	var target := clampi(GameState.max_unlocked_level, 1, 5)
	get_tree().change_scene_to_file("res://level%d.tscn" % target)

func _on_levels_pressed() -> void:
	get_tree().change_scene_to_file("res://level_select.tscn")

func _on_characters_pressed() -> void:
	get_tree().change_scene_to_file("res://character_select.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
