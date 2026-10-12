extends Area2D

var completed := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if completed or not body is CharacterBody2D:
		return

	completed = true
	var level := get_parent()
	var hud := level.get_node("HUD")
	var victory := hud.get_node("VictoryOverlay")
	var fragments := int(level.get("fragments"))
	var summary: Dictionary = level.get_run_summary()
	GameState.submit_grade(1, str(summary["grade"]))

	body.velocity = Vector2.ZERO
	body.set_physics_process(false)
	AudioManager.play_sfx("victory")

	if level.has_node("Drone"):
		level.get_node("Drone").set_process(false)

	hud.get_node("Title").visible = false
	hud.get_node("Controls").visible = false
	hud.get_node("FragmentCounter").visible = false
	victory.show_victory(fragments, summary)
