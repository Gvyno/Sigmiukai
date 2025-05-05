extends CharacterBody2D

@export var speed: float = 200.0
@export var damage: int = 10
@export var max_health: int = 500

@export var dash_speed: float = 500.0
@export var glide_speed: float = 225.0
@export var dash_interval: float = 3
@export var dash_duration: float = 0.2
@export var momentum_blend_speed: float = 5.0

var current_health: int
var target: Node2D = null
var attack_cooldown := true
var is_alive := true

var min_health = 0
var health = max_health
var max_mana = 50
var min_mana = 0
var mana = 50
var enemy_attackcooldown = true

signal health_changed(new_health, new_min_health, new_max_health)

var is_dashing = false
var dash_direction := Vector2.ZERO

func _ready():
	current_health = max_health
	print(is_alive)
	$SpriteIdle.visible = true
	$AnimationPlayer.play("Idle")

	$DetectionArea.body_entered.connect(_on_detection_body_entered)
	$DetectionArea.body_exited.connect(_on_detection_body_exited)

	if has_node("AttackCooldown"):
		$AttackCooldown.timeout.connect(_on_attack_cooldown_timeout)

	# Setup Dash Timer
	var dash_timer = Timer.new()
	dash_timer.name = "DashTimer"
	dash_timer.wait_time = dash_interval
	dash_timer.autostart = true
	dash_timer.one_shot = false
	add_child(dash_timer)
	dash_timer.timeout.connect(_on_dash_timer_timeout)

	emit_signal("health_changed", health, min_health, max_health)

func _physics_process(delta):
	if not is_alive:
		return

	if target:
		var to_target = (target.global_position - global_position).normalized()

		if is_dashing:
			velocity = dash_direction * dash_speed
		else:
			var target_velocity = to_target * glide_speed
			velocity = velocity.lerp(target_velocity, delta * momentum_blend_speed)

		move_and_slide()
		
		var should_flip = target.global_position.x > global_position.x
		$SpriteIdle.flip_h = should_flip
		$SpriteAttack.flip_h = should_flip

	else:
		velocity = velocity.lerp(Vector2.ZERO, delta * momentum_blend_speed)

func _on_dash_timer_timeout():
	if not is_alive or target == null:
		return

	is_dashing = true
	dash_direction = (target.global_position - global_position).normalized()
	velocity = dash_direction * dash_speed

	# Switch to attack sprite and play attack animation
	$SpriteIdle.visible = false
	$SpriteAttack.visible = true
	$AnimationPlayer.play("Attack")

	knockbackAttackPlayer()

	# Wait for duration of attack (0.4s) then return to idle
	await get_tree().create_timer(0.4).timeout
	$SpriteAttack.visible = false
	$SpriteIdle.visible = true
	$AnimationPlayer.play("Idle")

	# End dash after dash duration
	await get_tree().create_timer(dash_duration - 0.4).timeout
	is_dashing = false


func _on_detection_body_entered(body):
	if body.is_in_group("player"):
		target = body

func _on_detection_body_exited(body):
	if body == target:
		target = null

func _on_hurt_box_area_entered(hitbox: Hitbox) -> void:
	if is_alive:
		if enemy_attackcooldown == true:
			health -= hitbox.get("Damage")
			emit_signal("health_changed", health, min_health, max_health)
			knockbackTakeDamage()
			if health <= min_health:
				die()
			enemy_attackcooldown = false
			$AttackCooldown.start()

func _on_attack_cooldown_timeout():
	attack_cooldown = true
	enemy_attackcooldown = true

func die():
	is_alive = false
	velocity = Vector2.ZERO
	$AnimationPlayer.play("Idle")
	await get_tree().create_timer(0.5).timeout
	queue_free()



func knockbackTakeDamage():
	velocity.y = -50 # simulate bounce up
	velocity.x = -50  
#	var knockbackDirection= (-velocity)
#	velocity = knockbackDirection
#	print_debug(velocity)
#	print_debug(position)
	move_and_slide()
#	print_debug(position)
#	print_debug("    ")
	print("OWKNOCKEDBYPLAYER!")
	
func knockbackAttackPlayer():
	velocity.y = -500 # simulate bounce up
	velocity.x = -500  
#	var knockbackDirection= (-velocity)
#	velocity = knockbackDirection
#	print_debug(velocity)
#	print_debug(position)
	move_and_slide()
#	print_debug(position)
#	print_debug("    ")
	print("ISTEPAWAYFROMPLEYER HEHE!")
