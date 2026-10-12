extends Area2D

@export var message := "SPIKES — timing beats every form."
var cooldown := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if cooldown or not body is CharacterBody2D:
		return
	cooldown = true
	var level := get_parent()
	if level.has_method("respawn_player"):
		level.respawn_player(message)
	await get_tree().create_timer(0.5).timeout
	cooldown = false
