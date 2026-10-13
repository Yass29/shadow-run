extends Area2D

@export var memory_id := "M01"
@export_multiline var memory_text := "A memory returns."
@export var shard_reward := 2
var collected := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	rotation += delta * 0.4
	if has_node("Visual"):
		$Visual.scale = Vector2.ONE * (1.0 + sin(Time.get_ticks_msec() * 0.008) * 0.08)

func _on_body_entered(body: Node) -> void:
	if collected or not body is CharacterBody2D:
		return
	if not bool(body.get("is_shadow")):
		return
	collected = true
	GameState.unlock_memory(memory_id, memory_text)
	GameState.add_shards(shard_reward)
	AudioManager.play_sfx("shard")
	var level := get_parent()
	if level.has_method("show_memory"):
		level.show_memory(memory_id, memory_text)
	queue_free()
