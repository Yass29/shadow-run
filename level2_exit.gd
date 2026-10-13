extends Area2D

var completed := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _unhandled_input(event: InputEvent) -> void:
	if not completed:
		return

	if event.is_action_pressed("ui_accept"):
		ScreenTransition.change_scene("res://level3.tscn", "LEVEL 03", "RAIN DISTRICT")
	elif event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_R:
		get_tree().reload_current_scene()

func _on_body_entered(body: Node) -> void:
	if completed or not body is CharacterBody2D:
		return

	completed = true
	GameState.unlock_level(3)
	var level := get_parent()
	var hud := level.get_node("HUD")
	var summary: Dictionary = level.get_run_summary()
	GameState.submit_time(2, float(summary["time"]))
	GameState.submit_grade(2, str(summary["grade"]))
	body.velocity = Vector2.ZERO
	body.set_physics_process(false)
	AudioManager.play_sfx("victory")

	hud.get_node("Title").visible = false
	hud.get_node("Controls").visible = false
	hud.get_node("FragmentCounter").visible = false
	hud.get_node("ResultOverlay/Card/Stats").text = "GRADE %s   •   %.1fs   •   %d deaths   •   ◆ %d" % [summary["grade"], float(summary["time"]), int(summary["deaths"]), GameState.shadow_shards]
	hud.get_node("ResultOverlay").visible = true
