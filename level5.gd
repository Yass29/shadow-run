extends Node2D

var checkpoint := Vector2(140, 420)
var fragments := 0
var respawning := false
var elapsed_time := 0.0
var deaths := 0
const PAR_TIME := 90.0

@onready var player: CharacterBody2D = $Player
@onready var counter: Label = $HUD/FragmentCounter
@onready var alert: Label = $HUD/AlertMessage

func _ready() -> void:
	update_counter()
	$Exit.monitoring = false
	$Exit.visible = false
	$HUD/BossMessage.visible = false

func _process(_delta: float) -> void:
	elapsed_time += _delta
	if player.position.x > 1900.0 and checkpoint.x < 1900.0:
		checkpoint = Vector2(1930, 420)
		AudioManager.play_sfx("checkpoint")
		FXManager.checkpoint_burst(checkpoint)
	if player.position.y > 720.0:
		respawn_player("THE CORE REJECTED YOU.")

func collect_fragment() -> void:
	fragments += 1
	update_counter()

func update_counter() -> void:
	counter.text = "CORE %d / 3   ◆ %d" % [fragments, GameState.shadow_shards]

func respawn_player(message: String = "CORE DEFENSE TRIGGERED.") -> void:
	if respawning:
		return
	respawning = true
	deaths += 1
	AudioManager.play_sfx("alert")
	alert.text = message
	alert.visible = true
	player.position = checkpoint
	player.velocity = Vector2.ZERO
	await get_tree().create_timer(0.75).timeout
	alert.visible = false
	respawning = false


func start_boss_encounter() -> void:
	if checkpoint.x < 3290.0:
		checkpoint = Vector2(3290, 420)
		AudioManager.play_sfx("checkpoint")
		FXManager.checkpoint_burst(checkpoint)
	$HUD/BossMessage.text = "CORE SENTINEL — vanish during SCAN, touch both anchors in SHADOW."
	$HUD/BossMessage.visible = true

func boss_hit(hits: int) -> void:
	$HUD/BossMessage.text = "CORE SENTINEL   ANCHORS %d / 2" % hits

func boss_defeated() -> void:
	$HUD/BossMessage.text = "CORE SENTINEL DOWN — EXIT OPEN."
	$Exit.visible = true
	$Exit.monitoring = true
	await get_tree().create_timer(2.0).timeout
	$HUD/BossMessage.visible = false

func get_run_summary() -> Dictionary:
	var grade := GameState.calculate_grade(elapsed_time, deaths, fragments, PAR_TIME)
	return {
		"grade": grade,
		"time": elapsed_time,
		"deaths": deaths,
		"fragments": fragments
	}
