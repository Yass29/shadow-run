extends Area2D

@export var patrol_distance := 130.0
@export var patrol_speed := 1.25

var start_x := 0.0
var time := 0.0
var cooldown := 0.0

@onready var light_cone: Polygon2D = $LightCone
@onready var eye: Polygon2D = $DroneBody/Eye

func _ready() -> void:
	start_x = position.x

func _process(delta: float) -> void:
	time += delta
	cooldown = max(cooldown - delta, 0.0)
	position.x = start_x + sin(time * patrol_speed) * patrol_distance

	var pulse := 0.78 + sin(time * 7.0) * 0.16
	eye.modulate.a = pulse
	light_cone.modulate.a = 0.28 + sin(time * 3.5) * 0.05

	if cooldown > 0.0:
		return

	for body in get_overlapping_bodies():
		if body is CharacterBody2D:
			var hidden_in_shadow := bool(body.get("is_shadow"))
			if not hidden_in_shadow:
				cooldown = 1.0
				var level := get_parent()
				if level.has_method("respawn_player"):
					level.respawn_player("DRONE ALERT — become your shadow.")
				break
