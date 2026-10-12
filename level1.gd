extends Node2D

var checkpoint := Vector2(150, 420)
var fragments := 0
var respawning := false

@onready var player: CharacterBody2D = $Player
@onready var checkpoint_message: Label = $HUD/CheckpointMessage
@onready var fragment_counter: Label = $HUD/FragmentCounter
@onready var alert_message: Label = $HUD/AlertMessage

func _ready() -> void:
	update_fragment_counter()

func _process(_delta: float) -> void:
	if player.position.x > 1250.0 and checkpoint.x < 1250.0:
		checkpoint = Vector2(1270, 420)
		checkpoint_message.visible = true
		await get_tree().create_timer(1.2).timeout
		checkpoint_message.visible = false

	if player.position.y > 720.0:
		respawn_player("You fell into the void.")

func collect_fragment() -> void:
	fragments += 1
	update_fragment_counter()

func update_fragment_counter() -> void:
	fragment_counter.text = "ENERGY %d / 3" % fragments

func respawn_player(message: String = "Detected.") -> void:
	if respawning:
		return

	respawning = true
	alert_message.text = message
	alert_message.visible = true
	player.position = checkpoint
	player.velocity = Vector2.ZERO

	await get_tree().create_timer(0.75).timeout
	alert_message.visible = false
	respawning = false
