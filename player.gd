extends CharacterBody2D

const SPEED := 270.0
const JUMP_VELOCITY := -470.0
const NORMAL_COLLISION_SIZE := Vector2(40, 68)
const SHADOW_COLLISION_SIZE := Vector2(76, 22)
const NORMAL_VISUAL_SCALE := Vector2.ONE
const SHADOW_VISUAL_SCALE := Vector2(1.25, 0.60)

var is_shadow := false
var facing := 1.0
var anim_time := 0.0
@export var shadow_dash_enabled := false
var dash_cooldown := 0.0
var dash_latched := false

@onready var body: Node2D = $Body
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var floor_shadow: Polygon2D = $FloorShadow
@onready var shadow_aura: Polygon2D = $ShadowAura

func _ready() -> void:
	collision.shape.size = NORMAL_COLLISION_SIZE
	body.scale = NORMAL_VISUAL_SCALE
	shadow_aura.modulate.a = 0.0
	collision_mask = 3

func _physics_process(delta: float) -> void:
	anim_time += delta
	dash_cooldown = max(dash_cooldown - delta, 0.0)

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
	handle_shadow_dash()
	move_and_slide()
	animate_character(direction, delta)

func handle_shadow_dash() -> void:
	var dash_pressed := Input.is_key_pressed(KEY_E)

	if not dash_pressed:
		dash_latched = false
		return

	if dash_latched or not shadow_dash_enabled or not is_shadow or dash_cooldown > 0.0:
		return

	dash_latched = true
	dash_cooldown = 0.65
	velocity.x = facing * 720.0
	velocity.y = 0.0

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
		body.modulate = body.modulate.lerp(Color(0.72, 0.45, 1.0, 1.0), min(delta * 10.0, 1.0))
		body.position.y = lerpf(body.position.y, 10.0, min(delta * 12.0, 1.0))
		body.rotation = lerpf(body.rotation, 0.0, min(delta * 12.0, 1.0))
		floor_shadow.scale = floor_shadow.scale.lerp(Vector2(1.6, 0.85), min(delta * 12.0, 1.0))
		floor_shadow.modulate = floor_shadow.modulate.lerp(Color(0.55, 0.30, 1.0, 0.75), min(delta * 10.0, 1.0))
		shadow_aura.modulate = shadow_aura.modulate.lerp(Color(0.72, 0.42, 1.0, 0.42), min(delta * 12.0, 1.0))
		var pulse := 1.0 + sin(anim_time * 8.0) * 0.08
		shadow_aura.scale = Vector2(1.18 * pulse, 0.82 * pulse)
		return

	body.modulate = body.modulate.lerp(Color.WHITE, min(delta * 10.0, 1.0))
	floor_shadow.scale = floor_shadow.scale.lerp(Vector2.ONE, min(delta * 10.0, 1.0))
	floor_shadow.modulate = floor_shadow.modulate.lerp(Color(1.0, 1.0, 1.0, 0.35), min(delta * 10.0, 1.0))
	shadow_aura.modulate.a = lerpf(shadow_aura.modulate.a, 0.0, min(delta * 12.0, 1.0))
	shadow_aura.scale = shadow_aura.scale.lerp(Vector2.ONE, min(delta * 10.0, 1.0))

	var moving: bool = abs(direction) > 0.01 and is_on_floor()
	var bob := sin(anim_time * 12.0) * 2.2 if moving else sin(anim_time * 3.0) * 1.0
	body.position.y = lerpf(body.position.y, bob, min(delta * 14.0, 1.0))

	if not is_on_floor():
		body.rotation = lerpf(body.rotation, clamp(velocity.y / 1800.0, -0.16, 0.16), min(delta * 8.0, 1.0))
	elif moving:
		body.rotation = lerpf(body.rotation, sin(anim_time * 12.0) * 0.035, min(delta * 12.0, 1.0))
	else:
		body.rotation = lerpf(body.rotation, 0.0, min(delta * 10.0, 1.0))

