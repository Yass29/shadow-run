extends Area2D

@export var target_path: NodePath
@export var hold_time := 0.7

var progress := 0.0
var activated := false
@onready var rune: Polygon2D = $Rune

func _process(delta: float) -> void:
	if activated:
		return

	var charging := false
	for body in get_overlapping_bodies():
		if body is CharacterBody2D and bool(body.get("is_shadow")):
			charging = true
			break

	if charging:
		progress += delta
		var pulse := 0.55 + sin(Time.get_ticks_msec() * 0.02) * 0.25
		rune.modulate = Color(0.82, 0.55, 1.0, pulse)
		if progress >= hold_time:
			activate()
	else:
		progress = max(progress - delta * 1.8, 0.0)
		rune.modulate = Color(1, 1, 1, 0.7)

func activate() -> void:
	activated = true
	rune.modulate = Color(0.45, 1.0, 0.85, 1.0)

	if target_path.is_empty():
		return

	var target := get_node_or_null(target_path)
	if target == null:
		return

	if target.has_node("CollisionShape2D"):
		target.get_node("CollisionShape2D").set_deferred("disabled", true)

	if target is CanvasItem:
		var tween := create_tween()
		tween.tween_property(target, "modulate:a", 0.0, 0.35)
