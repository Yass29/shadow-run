extends CharacterBody2D

const SPEED := 260.0
const JUMP_VELOCITY := -450.0
const NORMAL_COLLISION_SIZE := Vector2(52, 70)
const SHADOW_COLLISION_SIZE := Vector2(72, 24)
const NORMAL_SPRITE_SCALE := Vector2(0.55, 0.55)
const SHADOW_SPRITE_SCALE := Vector2(0.72, 0.20)

var is_shadow := false

func _ready() -> void:
	$Sprite2D.scale = NORMAL_SPRITE_SCALE
	$CollisionShape2D.shape.size = NORMAL_COLLISION_SIZE

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	set_shadow_mode(Input.is_key_pressed(KEY_SHIFT))
	move_and_slide()

func set_shadow_mode(enabled: bool) -> void:
	if is_shadow == enabled:
		return

	is_shadow = enabled
	var sprite := $Sprite2D
	var collision := $CollisionShape2D

	if is_shadow:
		sprite.modulate = Color(0.10, 0.08, 0.18, 1.0)
		sprite.scale = SHADOW_SPRITE_SCALE
		collision.shape.size = SHADOW_COLLISION_SIZE
	else:
		sprite.modulate = Color.WHITE
		sprite.scale = NORMAL_SPRITE_SCALE
		collision.shape.size = NORMAL_COLLISION_SIZE
