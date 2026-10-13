extends Area2D

@export var message := "DECOY SHARD — RUN."
var triggered := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	rotation += delta * 1.35
	if has_node("Visual"):
		$Visual.modulate.a = 0.72 + sin(Time.get_ticks_msec() * 0.012) * 0.20

func _on_body_entered(body: Node) -> void:
	if triggered or not body is CharacterBody2D:
		return
	triggered = true
	AudioManager.play_sfx("alert")
	var level := get_parent()
	if level.has_method("trigger_decoy"):
		level.trigger_decoy(global_position, message)
	queue_free()
