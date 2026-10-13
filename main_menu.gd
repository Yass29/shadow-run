extends Control

func _ready() -> void:
	$PlayButton.text = "CONTINUE LEVEL %02d" % GameState.max_unlocked_level
	$PlayButton.grab_focus()
	$ShardCounter.text = "◆ %d SHARDS" % GameState.shadow_shards
	$Progress.text = "LEVELS UNLOCKED  %d / 5" % GameState.max_unlocked_level

func _on_play_pressed() -> void:
	if not GameState.intro_seen and GameState.max_unlocked_level <= 1:
		ScreenTransition.change_scene("res://story_intro.tscn", "SHADOW RUN", "A CITY WITHOUT LIGHT.")
		return

	var target := clampi(GameState.max_unlocked_level, 1, 5)
	ScreenTransition.change_scene(
		"res://level%d.tscn" % target,
		"ENTERING DISTRICT %02d" % target,
		"Stay visible only when you choose to."
	)

func _on_levels_pressed() -> void:
	ScreenTransition.change_scene("res://level_select.tscn")

func _on_characters_pressed() -> void:
	ScreenTransition.change_scene("res://character_select.tscn")

func _on_memories_pressed() -> void:
	ScreenTransition.change_scene("res://memory_archive.tscn")

func _on_story_pressed() -> void:
	ScreenTransition.change_scene("res://story_intro.tscn", "STORY ARCHIVE", "THE NIGHT THE CORE BROKE.")

func _on_quit_pressed() -> void:
	get_tree().quit()
