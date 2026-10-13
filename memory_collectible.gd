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
	show_popup()
	var level := get_parent()
	if level.has_method("show_memory"):
		level.show_memory(memory_id, memory_text)
	queue_free()


func show_popup() -> void:
	var popup := Label.new()
	popup.text = "%s RECOVERED" % memory_id
	popup.position = global_position + Vector2(-70, -52)
	popup.add_theme_color_override("font_color", Color(0.88, 0.72, 1.0, 1.0))
	popup.add_theme_font_size_override("font_size", 18)
	get_tree().current_scene.add_child(popup)
	var tween := popup.create_tween()
	tween.set_parallel(true)
	tween.tween_property(popup, "position:y", popup.position.y - 38.0, 0.8)
	tween.tween_property(popup, "modulate:a", 0.0, 0.8)
	tween.set_parallel(false)
	tween.tween_callback(popup.queue_free)
