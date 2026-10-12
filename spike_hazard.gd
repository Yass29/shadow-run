extends Area2D

@export var message := "SPIKES — timing beats every form."
var cooldown := false
var time := 0.0

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	time += delta
	if has_node("Visual"):
		var visual: CanvasItem = $Visual
		visual.modulate = Color(1.0, 0.72 + sin(time * 7.0) * 0.18, 0.78, 1.0)

func _on_body_entered(body: Node) -> void:
	if cooldown or not body is CharacterBody2D:
		return
	cooldown = true
	var level := get_parent()
	if level.has_method("respawn_player"):
		level.respawn_player(message)
	await get_tree().create_timer(0.5).timeout
	cooldown = false
