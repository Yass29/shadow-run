extends Area2D

@export var reward := 2
@export var requires_shadow := true
var collected := false
var time := 0.0

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	time += delta
	if has_node("Visual"):
		var alpha := 0.28
		var player := get_parent().get_node_or_null("Player")
		if player != null and bool(player.get("is_shadow")):
			alpha = 0.92
		$Visual.modulate.a = alpha + sin(time * 5.0) * 0.06

func _on_body_entered(body: Node) -> void:
	if collected or not body is CharacterBody2D:
		return
	if requires_shadow and not bool(body.get("is_shadow")):
		return
	collected = true
	GameState.add_shards(reward)
	show_popup()
	queue_free()

func show_popup() -> void:
	var popup := Label.new()
	popup.text = "SECRET +%d ◆" % reward
	popup.position = global_position + Vector2(-42, -45)
	popup.add_theme_color_override("font_color", Color(0.95, 0.78, 1.0, 1.0))
	popup.add_theme_font_size_override("font_size", 18)
	get_tree().current_scene.add_child(popup)
	var tween := popup.create_tween()
	tween.set_parallel(true)
	tween.tween_property(popup, "position:y", popup.position.y - 36.0, 0.65)
	tween.tween_property(popup, "modulate:a", 0.0, 0.65)
	tween.set_parallel(false)
	tween.tween_callback(popup.queue_free)
