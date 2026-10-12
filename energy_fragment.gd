extends Area2D

var base_y := 0.0
var time := 0.0

func _ready() -> void:
	base_y = position.y
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	time += delta
	position.y = base_y + sin(time * 3.0) * 6.0
	rotation += delta * 0.9

func _on_body_entered(body: Node) -> void:
	if body is CharacterBody2D:
		queue_free()
