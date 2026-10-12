extends Node2D

var checkpoint := Vector2(140, 420)
var fragments := 0
var respawning := false

@onready var player: CharacterBody2D = $Player
@onready var counter: Label = $HUD/FragmentCounter
@onready var alert: Label = $HUD/AlertMessage

func _ready() -> void:
	update_counter()

func _process(_delta: float) -> void:
	if player.position.x > 1750.0 and checkpoint.x < 1750.0:
		checkpoint = Vector2(1780, 420)
	if player.position.y > 720.0:
		respawn_player("MISSED THE ROOFTOP.")

func collect_fragment() -> void:
	fragments += 1
	update_counter()

func update_counter() -> void:
	counter.text = "ENERGY %d / 3" % fragments

func respawn_player(message: String = "SEQUENCE FAILED.") -> void:
	if respawning:
		return
	respawning = true
	alert.text = message
	alert.visible = true
	player.position = checkpoint
	player.velocity = Vector2.ZERO
	await get_tree().create_timer(0.75).timeout
	alert.visible = false
	respawning = false
