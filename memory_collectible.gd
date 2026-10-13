extends Area2D

@export var memory_id := "M01"
@export_multiline var memory_text := "A memory returns."
@export var shard_reward := 2

var collected := false

func _ready() -> void:
	if GameState.unlocked_memories.has(memory_id):
		queue_free()
		return
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
	var reward_was_claimed := GameState.memory_master_reward_claimed
	GameState.unlock_memory(memory_id, memory_text)
	GameState.add_shards(shard_reward)
	var echo_unlocked := not reward_was_claimed and GameState.memory_master_reward_claimed

	AudioManager.play_sfx("shard")
	show_recovery_cinematic(echo_unlocked)

	var level := get_parent()
	if level.has_method("show_memory"):
		level.show_memory(memory_id, memory_text)

	queue_free()

func show_recovery_cinematic(echo_unlocked: bool) -> void:
	var canvas := CanvasLayer.new()
	canvas.layer = 85
	canvas.name = "MemoryRecovery"
	get_tree().current_scene.add_child(canvas)

	var flash := ColorRect.new()
	flash.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	flash.color = Color(0.60, 0.42, 1.0, 0.0)
	flash.mouse_filter = Control.MOUSE_FILTER_IGNORE
	canvas.add_child(flash)

	var band := ColorRect.new()
	band.position = Vector2(0, 218)
	band.size = Vector2(1150, 210)
	band.color = Color(0.015, 0.02, 0.055, 0.0)
	band.mouse_filter = Control.MOUSE_FILTER_IGNORE
	canvas.add_child(band)

	var accent := ColorRect.new()
	accent.position = Vector2(0, 0)
	accent.size = Vector2(8, 210)
	accent.color = Color(0.62, 0.42, 1.0, 0.0)
	band.add_child(accent)

	var title := Label.new()
	title.position = Vector2(110, 34)
	title.size = Vector2(930, 44)
	title.text = "MEMORY RECOVERED   //   %s" % memory_id
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 28)
	title.add_theme_color_override("font_color", Color(0.86, 0.82, 1.0, 1.0))
	title.modulate.a = 0.0
	band.add_child(title)

	var body_label := Label.new()
	body_label.position = Vector2(155, 88)
	body_label.size = Vector2(840, 54)
	body_label.text = memory_text
	body_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	body_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	body_label.add_theme_font_size_override("font_size", 16)
	body_label.add_theme_color_override("font_color", Color(0.70, 0.73, 0.88, 1.0))
	body_label.modulate.a = 0.0
	band.add_child(body_label)

	var reward_label := Label.new()
	reward_label.position = Vector2(155, 150)
	reward_label.size = Vector2(840, 34)
	reward_label.text = "ECHO UNLOCKED   •   +10 ◆ MEMORY MASTER BONUS" if echo_unlocked else "+%d ◆   •   MEMORY ARCHIVE UPDATED" % shard_reward
	reward_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	reward_label.add_theme_font_size_override("font_size", 15)
	reward_label.add_theme_color_override("font_color", Color(0.48, 1.0, 0.82, 1.0) if echo_unlocked else Color(0.55, 0.92, 1.0, 1.0))
	reward_label.modulate.a = 0.0
	band.add_child(reward_label)

	var tween := canvas.create_tween()
	tween.set_parallel(true)
	tween.tween_property(flash, "color:a", 0.20, 0.08)
	tween.tween_property(band, "color:a", 0.95, 0.22)
	tween.tween_property(accent, "color:a", 1.0, 0.22)
	tween.tween_property(title, "modulate:a", 1.0, 0.28)
	tween.tween_property(body_label, "modulate:a", 1.0, 0.38)
	tween.tween_property(reward_label, "modulate:a", 1.0, 0.44)
	await tween.finished

	flash.color.a = 0.0
	await get_tree().create_timer(1.35).timeout

	var out := canvas.create_tween()
	out.set_parallel(true)
	out.tween_property(band, "color:a", 0.0, 0.35)
	out.tween_property(accent, "color:a", 0.0, 0.35)
	out.tween_property(title, "modulate:a", 0.0, 0.28)
	out.tween_property(body_label, "modulate:a", 0.0, 0.28)
	out.tween_property(reward_label, "modulate:a", 0.0, 0.28)
	await out.finished
	canvas.queue_free()
