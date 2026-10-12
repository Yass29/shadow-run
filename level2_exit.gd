extends Area2D

var completed := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _unhandled_input(event: InputEvent) -> void:
	if not completed:
		return

	if event.is_action_pressed("ui_accept"):
		get_tree().change_scene_to_file("res://level3.tscn")
	elif event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_R:
		get_tree().reload_current_scene()

func _on_body_entered(body: Node) -> void:
	if completed or not body is CharacterBody2D:
		return

	completed = true
	var level := get_parent()
	var hud := level.get_node("HUD")
	body.velocity = Vector2.ZERO
	body.set_physics_process(false)

	hud.get_node("Title").visible = false
	hud.get_node("Controls").visible = false
	hud.get_node("FragmentCounter").visible = false
	hud.get_node("DemoComplete").visible = true
	hud.get_node("DemoHint").visible = true
