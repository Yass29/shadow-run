extends Node

func checkpoint_burst(world_position: Vector2) -> void:
	var ring := Polygon2D.new()
	ring.polygon = PackedVector2Array([
		Vector2(0, -22), Vector2(16, -16), Vector2(22, 0), Vector2(16, 16),
		Vector2(0, 22), Vector2(-16, 16), Vector2(-22, 0), Vector2(-16, -16)
	])
	ring.color = Color(0.35, 1.0, 0.86, 0.75)
	ring.global_position = world_position
	ring.z_index = 40
	get_tree().current_scene.add_child(ring)

	var tween := ring.create_tween()
	tween.set_parallel(true)
	tween.tween_property(ring, "scale", Vector2(2.6, 2.6), 0.42)
	tween.tween_property(ring, "modulate:a", 0.0, 0.42)
	tween.set_parallel(false)
	tween.tween_callback(ring.queue_free)
