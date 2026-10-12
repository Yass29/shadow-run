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
	body.velocity = Vector2.ZERO
	body.set_physics_process(false)

	hud.get_node("Title").visible = false
	hud.get_node("Controls").visible = false
	hud.get_node("FragmentCounter").visible = false
	hud.get_node("DemoComplete").visible = true
	hud.get_node("DemoHint").visible = true
