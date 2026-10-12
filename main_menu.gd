extends Control

func _ready() -> void:
	$PlayButton.grab_focus()

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://level1.tscn")

func _on_characters_pressed() -> void:
	get_tree().change_scene_to_file("res://character_select.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
