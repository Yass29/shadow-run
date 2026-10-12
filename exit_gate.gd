extends Area2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body is CharacterBody2D:
		var complete_label := get_parent().get_node("HUD/LevelComplete")
		complete_label.visible = true
		body.velocity = Vector2.ZERO
		body.set_physics_process(false)
