extends Node2D

var checkpoint := Vector2(150, 420)

@onready var player: CharacterBody2D = $Player
@onready var checkpoint_message: Label = $HUD/CheckpointMessage

func _process(_delta: float) -> void:
	if player.position.x > 1250.0 and checkpoint.x < 1250.0:
		checkpoint = Vector2(1270, 420)
		checkpoint_message.visible = true
		await get_tree().create_timer(1.2).timeout
		checkpoint_message.visible = false

	if player.position.y > 720.0:
		player.position = checkpoint
		player.velocity = Vector2.ZERO
