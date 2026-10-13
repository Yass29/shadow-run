extends Area2D

var completed := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _unhandled_input(event: InputEvent) -> void:
	if not completed:
		return
	if event.is_action_pressed("ui_accept"):
		ScreenTransition.change_scene("res://level6.tscn", "LEVEL 06", "MEMORY VAULT")
	elif event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_R:
		get_tree().reload_current_scene()

func _on_body_entered(body: Node) -> void:
	if completed or not body is CharacterBody2D:
		return
	completed = true
	GameState.unlock_level(6)
	body.velocity = Vector2.ZERO
	body.set_physics_process(false)
	AudioManager.play_sfx("victory")
	var level := get_parent()
	var hud := level.get_node("HUD")
	var summary: Dictionary = level.get_run_summary()
	var new_record := GameState.submit_time(5, float(summary["time"]))
	GameState.submit_grade(5, str(summary["grade"]))
	hud.get_node("Title").visible = false
	hud.get_node("Controls").visible = false
	hud.get_node("FragmentCounter").visible = false
	hud.get_node("Finale/Card/Text").text = "GRADE %s   •   %.1fs   •   %d deaths   •   ◆ %d shards%s" % [summary["grade"], float(summary["time"]), int(summary["deaths"]), GameState.shadow_shards, "   •   NEW BEST" if new_record else ""]
	hud.get_node("Finale").visible = true
