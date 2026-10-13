extends Area2D

var base_y := 0.0
var time := 0.0
var collected := false

func _ready() -> void:
	base_y = position.y
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	time += delta
	position.y = base_y + sin(time * 3.0) * 6.0
	rotation += delta * 0.9

func _on_body_entered(body: Node) -> void:
	if collected or not body is CharacterBody2D:
		return

	collected = true
	var level := get_parent()
	var combo: Dictionary = GameState.collect_combo_shard()
	AudioManager.play_sfx("shard")
	if level.has_method("collect_fragment"):
		level.collect_fragment()
	show_pickup_popup(int(combo["reward"]), int(combo["combo"]))
	queue_free()


func show_pickup_popup(reward: int, combo: int) -> void:
	var popup := Label.new()
	popup.text = "+%d ◆   x%d" % [reward, combo] if combo > 1 else "+%d ◆" % reward
	popup.position = global_position + Vector2(-22, -42)
	popup.add_theme_color_override("font_color", Color(0.60, 0.92, 1.0, 1.0))
	popup.add_theme_font_size_override("font_size", 18)
	get_tree().current_scene.add_child(popup)

	var tween := popup.create_tween()
	tween.set_parallel(true)
	tween.tween_property(popup, "position:y", popup.position.y - 34.0, 0.55)
	tween.tween_property(popup, "modulate:a", 0.0, 0.55)
	tween.set_parallel(false)
	tween.tween_callback(popup.queue_free)
