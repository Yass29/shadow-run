extends StaticBody2D

var open := false

func open_for(duration: float) -> void:
	if open:
		return
	open = true
	$CollisionShape2D.set_deferred("disabled", true)
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 0.12, 0.25)
	await get_tree().create_timer(duration).timeout
	$CollisionShape2D.set_deferred("disabled", false)
	var close_tween := create_tween()
	close_tween.tween_property(self, "modulate:a", 1.0, 0.2)
	open = false
