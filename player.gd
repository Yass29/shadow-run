extends CharacterBody2D

const SPEED := 270.0
const JUMP_VELOCITY := -470.0
const NORMAL_COLLISION_SIZE := Vector2(40, 68)
const SHADOW_COLLISION_SIZE := Vector2(76, 22)
const NORMAL_VISUAL_SCALE := Vector2.ONE
const SHADOW_VISUAL_SCALE := Vector2(1.45, 0.42)

var is_shadow := false
var facing := 1.0
var anim_time := 0.0

@onready var body: Node2D = $Body
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var floor_shadow: Polygon2D = $FloorShadow

func _ready() -> void:
	collision.shape.size = NORMAL_COLLISION_SIZE
	body.scale = NORMAL_VISUAL_SCALE
	collision_mask = 3

func _physics_process(delta: float) -> void:
	anim_time += delta

	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and not is_shadow:
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		facing = sign(direction)
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * 5.0 * delta)

	set_shadow_mode(Input.is_key_pressed(KEY_SHIFT))
	move_and_slide()
	animate_character(direction, delta)

func set_shadow_mode(enabled: bool) -> void:
	if is_shadow == enabled:
		return

	is_shadow = enabled

	if is_shadow:
		collision.shape.size = SHADOW_COLLISION_SIZE
		collision_mask = 1
	else:
		collision.shape.size = NORMAL_COLLISION_SIZE
		collision_mask = 3

func animate_character(direction: float, delta: float) -> void:
	var base_scale := SHADOW_VISUAL_SCALE if is_shadow else NORMAL_VISUAL_SCALE
	var target_scale := Vector2(base_scale.x * facing, base_scale.y)
	body.scale = body.scale.lerp(target_scale, min(delta * 13.0, 1.0))

	if is_shadow:
		body.modulate = body.modulate.lerp(Color(0.72, 0.48, 1.0, 1.0), min(delta * 10.0, 1.0))
		body.position.y = lerpf(body.position.y, 18.0, min(delta * 12.0, 1.0))
		body.rotation = lerpf(body.rotation, 0.0, min(delta * 12.0, 1.0))
		floor_shadow.scale = floor_shadow.scale.lerp(Vector2(1.8, 0.75), min(delta * 12.0, 1.0))
		floor_shadow.modulate = floor_shadow.modulate.lerp(Color(0.55, 0.28, 0.95, 0.62), min(delta * 10.0, 1.0))
		return

	body.modulate = body.modulate.lerp(Color.WHITE, min(delta * 10.0, 1.0))
	floor_shadow.scale = floor_shadow.scale.lerp(Vector2.ONE, min(delta * 10.0, 1.0))
	floor_shadow.modulate = floor_shadow.modulate.lerp(Color(1.0, 1.0, 1.0, 0.35), min(delta * 10.0, 1.0))

	var moving: bool = abs(direction) > 0.01 and is_on_floor()
	var bob := sin(anim_time * 12.0) * 2.2 if moving else sin(anim_time * 3.0) * 1.0
	body.position.y = lerpf(body.position.y, bob, min(delta * 14.0, 1.0))

	if not is_on_floor():
		body.rotation = lerpf(body.rotation, clamp(velocity.y / 1800.0, -0.16, 0.16), min(delta * 8.0, 1.0))
	elif moving:
		body.rotation = lerpf(body.rotation, sin(anim_time * 12.0) * 0.035, min(delta * 12.0, 1.0))
	else:
		body.rotation = lerpf(body.rotation, 0.0, min(delta * 10.0, 1.0))

