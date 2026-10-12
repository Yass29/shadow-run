extends AnimatableBody2D

@export var travel := Vector2(180, 0)
@export var speed := 1.2
@export var phase := 0.0

var start_position := Vector2.ZERO
var time := 0.0

func _ready() -> void:
	start_position = position

func _physics_process(delta: float) -> void:
	time += delta
	var t := (sin(time * speed + phase) + 1.0) * 0.5
	position = start_position + travel * t
