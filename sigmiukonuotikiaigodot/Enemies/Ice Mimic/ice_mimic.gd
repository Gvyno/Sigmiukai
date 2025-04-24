extends CharacterBody2D

@export var speed: float = 175.0
@export var damage: int = 10
@export var max_health: int = 80

var current_health: int
var target: Node2D = null
var attack_cooldown := true
var is_alive := true

var player_chase = false
var player = null
const GRAVITY = 2055
const JUMP_VELOCITY = -500.0

signal health_changed(new_health, new_min_health, new_max_health)

var min_health = 0
var health = max_health
var max_mana = 50
var min_mana = 0
var mana = 50
var enemy_attackcooldown = true

func _ready():
	current_health = max_health
	print(is_alive)

	$SpriteIdle.visible = true
	$AnimationPlayer.play("Idle")

	$DetectionArea.body_entered.connect(_on_detection_body_entered)
	$DetectionArea.body_exited.connect(_on_detection_body_exited)

	if has_node("AttackCooldown"):
		$AttackCooldown.timeout.connect(_on_attack_cooldown_timeout)

	if has_node("JumpTimer"):
		$JumpTimer.timeout.connect(_on_jump_timer_timeout)

	emit_signal("health_changed", health, min_health, max_health)

func _physics_process(delta):
	if not is_alive:
		return

	# Apply gravity
	velocity.y += GRAVITY * delta

	# Move horizontally only when in the air and player is detected
	if target and not is_on_floor():
		var direction = (target.global_position - global_position).normalized()
		velocity.x = direction.x * speed
		$SpriteIdle.flip_h = target.global_position.x < global_position.x
		$SpriteAttack.flip_h = target.global_position.x >  global_position.x
	else:
		velocity.x = 0

	move_and_slide()

func _on_detection_body_entered(body):
	if body.is_in_group("player"):
		target = body
		$SpriteIdle.set_visible(false)
		$SpriteAttack.set_visible(true)
		$AnimationPlayer.play("Attack")
		$HealthBar.set_visible(true)
		$JumpTimer.start()

func _on_detection_body_exited(body):
	if body == target:
		target = null
		$SpriteIdle.set_visible(true)
		$SpriteAttack.set_visible(false)
		$AnimationPlayer.stop
		$JumpTimer.stop()

func _on_jump_timer_timeout():
	if target and is_on_floor():
		velocity.y = JUMP_VELOCITY

func _on_hurt_box_area_entered(hitbox: Hitbox) -> void:
	if is_alive:
		if enemy_attackcooldown == true:
			health -= hitbox.get("Damage")
			emit_signal("health_changed", health, min_health, max_health)
			if health <= min_health:
				die()
			enemy_attackcooldown = false
			$AttackCooldown.start()

func die():
	is_alive = false
	velocity = Vector2.ZERO
	$AnimationPlayer.play("Idle")
	await get_tree().create_timer(0.5).timeout
	queue_free()

func _on_attack_cooldown_timeout():
	attack_cooldown = true
	enemy_attackcooldown = true
