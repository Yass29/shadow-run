extends Area2D

@export var patrol_distance := 150.0
@export var patrol_speed := 1.2
@export var vertical_bob := 10.0

var start_position := Vector2.ZERO
var time := 0.0
var cooldown := 0.0

@onready var light_cone: Polygon2D = $LightCone
@onready var eye: Polygon2D = $DroneBody/Eye

func _ready() -> void:
	start_position = position

func _process(delta: float) -> void:
	time += delta
	cooldown = max(cooldown - delta, 0.0)

	position.x = start_position.x + sin(time * patrol_speed) * patrol_distance
	position.y = start_position.y + sin(time * patrol_speed * 1.7) * vertical_bob

	var pulse := 0.78 + sin(time * 7.0) * 0.16
	eye.modulate.a = pulse
	light_cone.modulate.a = 0.24 + sin(time * 3.5) * 0.07

	if cooldown > 0.0:
		return

	for body in get_overlapping_bodies():
		if body is CharacterBody2D and not bool(body.get("is_shadow")):
			cooldown = 1.0
			var level := get_parent()
			if level.has_method("respawn_player"):
				level.respawn_player("DRONE ALERT — break line of sight or become shadow.")
			break
