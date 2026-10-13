extends Area2D

@export var target_path: NodePath
@export var open_duration := 4.0

var armed := true
@onready var visual: Polygon2D = $Visual

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if not armed or not body is CharacterBody2D:
		return
	armed = false
	visual.modulate = Color(0.45, 1.0, 0.82, 1.0)
	AudioManager.play_sfx("checkpoint")

	var target := get_node_or_null(target_path)
	if target != null:
		target.open_for(open_duration)

	await get_tree().create_timer(open_duration + 0.2).timeout
	armed = true
	visual.modulate = Color.WHITE
