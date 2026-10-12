extends ColorRect

@export var min_delay := 2.5
@export var max_delay := 6.0

var timer := 2.0
var flash_time := 0.0

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	color = Color(0.55, 0.72, 1.0, 0.0)

func _process(delta: float) -> void:
	timer -= delta
	flash_time = max(flash_time - delta, 0.0)

	if timer <= 0.0:
		flash_time = 0.13
		timer = randf_range(min_delay, max_delay)

	if flash_time > 0.0:
		color.a = 0.16 + sin(flash_time * 90.0) * 0.08
	else:
		color.a = lerpf(color.a, 0.0, min(delta * 14.0, 1.0))
