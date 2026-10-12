extends Area2D

var base_y := 0.0
var time := 0.0
var collected := false

func _ready() -> void:
	base_y = position.y
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	time += delta
	position.y = base_y + sin(time * 3.0) * 6.0
	rotation += delta * 0.9

func _on_body_entered(body: Node) -> void:
	if collected or not body is CharacterBody2D:
		return

	collected = true
	var level := get_parent()
	if level.has_method("collect_fragment"):
		level.collect_fragment()
	GameState.add_shards(1)
	queue_free()
