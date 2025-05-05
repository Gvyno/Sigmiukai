extends CharacterBody2D

@export var speed: float = 250
@export var damage: int = 10
@export var max_health: int = 1000

var GRAVITY = 2055
const JUMP_VELOCITY = -500.0

var current_health: int
var target: Node2D = null
var attack_cooldown := true
var is_alive := true
var target_chase = false

signal health_changed(new_health, new_min_health, new_max_health)
signal mana_changed(new_mana, new_min_mana, new_max_mana)

var ROLLINTIMEOFF = false
var ROLLIN = true
var CHOMPING = true

var min_health = 0
var health = max_health
var max_mana = 50
var min_mana = 0
var mana = 50

var rollspeed = speed 
var walkspeed = speed / 2

func _ready():
	current_health = max_health
	mana = max_mana
	emit_signal("health_changed", health, min_health, max_health)
	emit_signal("mana_changed", mana, min_mana, max_mana)
	print(is_alive)

	$FTWIdle.visible = true
	$AnimationPlayer.play("Idle")

	$DetectionArea.body_entered.connect(_on_detection_area_body_entered)
	$DetectionArea.body_exited.connect(_on_detection_area_body_exited)

	if has_node("AttackCooldown"):
		$AttackCooldown.timeout.connect(_on_attack_cooldown_timeout)
	if has_node("JumpTimer"):
		$JumpTimer.timeout.connect(_on_jump_timer_timeout)

func _physics_process(delta):
	emit_signal("health_changed", health, min_health, max_health)
	emit_signal("mana_changed", mana, min_mana, max_mana)

	if not is_alive:
		return

	# Gravity
	velocity.y += GRAVITY * delta

	if target:
		var direction = (target.global_position - global_position).normalized()

		if is_on_floor():
			velocity.x = direction.x * walkspeed
		else:
			velocity.x = direction.x * rollspeed * 3  # Stronger force mid-air

		# Flip visuals
		var facing_right = target.global_position.x > global_position.x
		$FTWIdle.flip_h = facing_right
		$FTWRotate.flip_h = facing_right
		$FTWBash.flip_h = facing_right
		$FTWWalk.flip_h = facing_right
	else:
		velocity.x = 0

	update_animation()
	move_and_slide()

func update_animation():
	if is_on_floor():
		speed = walkspeed
		GRAVITY = 1500
		ROLLIN = false

		$Hitbox.set_collision_layer_value(4, false)
		$FTWRotate.visible = false
		$FTWIdle.visible = false

		if CHOMPING:
			$HitBoxBash.set_collision_layer_value(4, true)
			$FTWBash.visible = true
			$FTWWalk.visible = false
			$AnimationPlayer.play("Bash")
		else:
			$HitBoxBash.set_collision_layer_value(4, false)
			$FTWBash.visible = false
			$FTWWalk.visible = true
			$AnimationPlayer.play("Walk")
	else:
		speed = rollspeed
		$Hitbox.set_collision_layer_value(4, true)
		$HitBoxBash.set_collision_layer_value(4, false)
		$FTWBash.visible = false
		$FTWWalk.visible = false
		$FTWIdle.visible = false
		$FTWRotate.visible = true
		$AnimationPlayer.play("Rotate")

func _on_hurt_box_area_entered(hitbox: Hitbox) -> void:
	if is_alive and attack_cooldown:
		health -= hitbox.get("Damage")
		knockbackAttackPlayer(hitbox.get("Knockback"))
		emit_signal("health_changed", health, min_health, max_health)
		emit_signal("mana_changed", mana, min_mana, max_mana)
		if health <= min_health:
			die()
		attack_cooldown = false
		$AttackCooldown.start()

func die():
	is_alive = false
	velocity = Vector2.ZERO
	$AnimationPlayer.play("Idle")
	await get_tree().create_timer(0.5).timeout
	BossesState.ice_caves_boss_dead = true
	queue_free()

func _on_attack_cooldown_timeout() -> void:
	$HitBoxBash/CollisionShape2D.disabled = true
	$HitBoxBash/CollisionShape2D.disabled = false
	attack_cooldown = true

func _on_damage_cooldown_timeout() -> void:
	pass

func _on_detection_area_body_entered(body):
	if body.is_in_group("player"):
		target = body
		$FTWIdle.visible = false
		$FTWWalk.visible = false
		$FTWBash.visible = false
		$FTWRotate.visible = true
		$AnimationPlayer.play("Rotate")
		$HealthBar.visible = true
		speed *= 1
		$Rolling.start()
		$JumpTimer.start()

func _on_detection_area_body_exited(body):
	if body == target:
		target = null
		$FTWIdle.visible = true
		$FTWRotate.visible = false
		speed /= 2
		$Rolling.stop()

func knockbackAttackPlayer(Force: int):
	print("test")
	move_and_slide()

func _on_hitbox_area_entered(hitbox: Hitbox) -> void:
	knockbackAttackPlayer(hitbox.get("Knockback"))

func _on_detection_area_bash_body_entered(body: Node2D) -> void:
	if body == target:
		CHOMPING = true
		$FTWIdle.visible = false
		$FTWWalk.visible = false
		$FTWRotate.visible = false
		$FTWBash.visible = true
		$AnimationPlayer.play("Bash")

func _on_detection_area_bash_body_exited(body: Node2D) -> void:
	if body == target:
		CHOMPING = false
		$FTWIdle.visible = false
		$FTWWalk.visible = true
		$FTWRotate.visible = false
		$FTWBash.visible = false
		$AnimationPlayer.play("Walk")

func _on_hit_box_bash_area_entered(area: Area2D) -> void:
	pass

func _on_hurt_box_shell_area_entered(hitbox: Hitbox) -> void:
	if is_alive and attack_cooldown:
		emit_signal("health_changed", health, min_health, max_health)
		emit_signal("mana_changed", mana, min_mana, max_mana)
		if health <= min_health:
			die()
		attack_cooldown = false
		$AttackCooldown.start()

func _on_detection_area_no_roll_body_entered(body: Node2D) -> void:
	if body == target:
		ROLLINTIMEOFF = true
		$FTWIdle.visible = false
		$FTWWalk.visible = true
		$FTWRotate.visible = false
		$FTWBash.visible = false
		$AnimationPlayer.play("Walk")
		$JumpTimer.stop()

func _on_detection_area_no_roll_body_exited(body: Node2D) -> void:
	if body == target:
		ROLLIN = true
		ROLLINTIMEOFF = false
		$FTWIdle.visible = false
		$FTWWalk.visible = false
		$FTWRotate.visible = true
		$FTWBash.visible = false
		$Rolling.start()
		$JumpTimer.start()

func _on_rolling_timeout() -> void:
	if ROLLINTIMEOFF:
		ROLLIN = false
	print("Rolling timeout")

func _on_jump_timer_timeout() -> void:
	if target and is_on_floor():
		velocity.y = JUMP_VELOCITY
		print("Jumping toward target")
