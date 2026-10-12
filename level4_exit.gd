extends Area2D

var completed := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _unhandled_input(event: InputEvent) -> void:
	if not completed:
		return
	if event.is_action_pressed("ui_accept"):
		get_tree().change_scene_to_file("res://level5.tscn")
	elif event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_R:
		get_tree().reload_current_scene()

func _on_body_entered(body: Node) -> void:
	if completed or not body is CharacterBody2D:
		return
	completed = true
	GameState.unlock_level(5)
	body.velocity = Vector2.ZERO
	body.set_physics_process(false)
	var level := get_parent()
	var hud := level.get_node("HUD")
	var summary: Dictionary = level.get_run_summary()
	GameState.submit_grade(4, str(summary["grade"]))
	hud.get_node("Title").visible = false
	hud.get_node("Controls").visible = false
	hud.get_node("FragmentCounter").visible = false
	hud.get_node("Complete").text = "BLACKOUT TOWER CLEARED\nGRADE %s   •   %.1fs   •   %d deaths\nENTER  FINAL CORE RUN     R  replay" % [summary["grade"], float(summary["time"]), int(summary["deaths"])]
	hud.get_node("Complete").visible = true
