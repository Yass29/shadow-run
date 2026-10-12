extends Control

@export var skin_id := "shade"

func _ready() -> void:
	custom_minimum_size = Vector2(190, 150)
	queue_redraw()

func _draw() -> void:
	if not GameState.SKINS.has(skin_id):
		return
	var skin = GameState.SKINS[skin_id]
	var center := Vector2(size.x * 0.5, 78.0)

	draw_circle(center + Vector2(0, 8), 48.0, Color(0.05, 0.055, 0.11, 1.0))
	draw_colored_polygon(
		PackedVector2Array([
			center + Vector2(-36, 18),
			center + Vector2(30, 12),
			center + Vector2(48, 52),
			center + Vector2(-48, 52)
		]),
		skin["cape"]
	)
	draw_colored_polygon(
		PackedVector2Array([
			center + Vector2(-24, 0),
			center + Vector2(24, 0),
			center + Vector2(30, 44),
			center + Vector2(-30, 44)
		]),
		skin["torso"]
	)
	draw_circle(center + Vector2(0, -24), 26.0, skin["head"])
	draw_line(center + Vector2(-14, -24), center + Vector2(-4, -24), skin["eyes"], 4.0)
	draw_line(center + Vector2(4, -24), center + Vector2(14, -24), skin["eyes"], 4.0)
	draw_line(center + Vector2(-18, 2), center + Vector2(30, 10), skin["scarf"], 7.0)
	draw_circle(center + Vector2(0, 22), 7.0, skin["core"])
