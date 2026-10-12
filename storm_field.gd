extends Area2D

var cooldown := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if cooldown or not body is CharacterBody2D:
		return

	if bool(body.get("is_shadow")):
		return

	cooldown = true
	var level := get_parent()
	if level.has_method("respawn_player"):
		level.respawn_player("ELECTRIC RAIN — become your shadow.")
	await get_tree().create_timer(0.6).timeout
	cooldown = false
