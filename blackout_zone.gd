extends Area2D

@export var darkness := 0.90
@export var shadow_visibility := 0.25

var bodies_inside := 0
var overlay: ColorRect

func _ready() -> void:
	body_entered.connect(_entered)
	body_exited.connect(_exited)

func _entered(body: Node) -> void:
	if not body is CharacterBody2D:
		return
	bodies_inside += 1
	create_overlay()

func _exited(body: Node) -> void:
	if not body is CharacterBody2D:
		return
	bodies_inside = max(bodies_inside - 1, 0)
	if bodies_inside == 0:
		remove_overlay()

func _process(_delta: float) -> void:
	if overlay == null:
		return
	var player := get_parent().get_node_or_null("Player")
	if player == null:
		return
	overlay.color.a = shadow_visibility if bool(player.get("is_shadow")) else darkness

func create_overlay() -> void:
	if overlay != null:
		return
	overlay = ColorRect.new()
	overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	overlay.color = Color(0.0, 0.0, 0.02, darkness)
	overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var canvas := CanvasLayer.new()
	canvas.layer = 70
	canvas.name = "BlackoutOverlay"
	get_tree().current_scene.add_child(canvas)
	canvas.add_child(overlay)

func remove_overlay() -> void:
	if overlay == null:
		return
	var canvas := overlay.get_parent()
	canvas.queue_free()
	overlay = null
