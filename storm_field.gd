extends Area2D

var cooldown := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if cooldown or not body is CharacterBody2D:
		return

	# Electric storm fields are dangerous specifically to the shadow form.
	# This forces the player to switch back to normal form instead of
	# staying in shadow through the whole level.
	if not bool(body.get("is_shadow")):
		return

	cooldown = true
	var level := get_parent()
	if level.has_method("respawn_player"):
		level.respawn_player("SHADOW OVERLOAD — return to normal form.")
	await get_tree().create_timer(0.6).timeout
	cooldown = false
