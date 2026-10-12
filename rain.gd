extends Node2D

var offset := 0.0

func _process(delta: float) -> void:
	offset = fmod(offset + delta * 520.0, 90.0)
	queue_redraw()

func _draw() -> void:
	for i in range(85):
		var x := float((i * 137) % 1150)
		var y := float((i * 73) % 647) + offset - 90.0
		draw_line(Vector2(x, y), Vector2(x - 10.0, y + 34.0), Color(0.45, 0.72, 1.0, 0.34), 2.0)
