extends CharacterBody2D

@export var speed: float = 150.0
@export var damage: int = 10
@export var max_health: int = 250
@export var Bat_scene: PackedScene = preload("res://Enemies/Boss DarkForest/enemy_blood_bat_boss.tscn")
@export var Rat_scene: PackedScene = preload("res://Enemies/Boss DarkForest/emeny_rat_boss.tscn")
 

const GRAVITY = 2055
#const speed = 300.0
const JUMP_VELOCITY = -400.0
var current_health: int
var target: Node2D = null
var attack_cooldown := true
var is_alive := true
var target_chase = false
#var player = null
signal health_changed(new_health, new_min_health, new_max_health)
signal mana_changed(new_mana, new_min_mana, new_max_mana)


var min_health = 0
var health = max_health
var max_mana = 50
var min_mana = 0
var mana = 50

func _ready():
	current_health = max_health
	mana=max_mana
	emit_signal("health_changed", health, min_health, max_health)
	emit_signal("mana_changed", mana,min_mana, max_mana)
	print(is_alive)
	
	$DFBIdle.visible = true
	$AnimationPlayer.play("Idle")

	$DetectionArea.body_entered.connect(_on_detection_area_body_entered)
	$DetectionArea.body_exited.connect(_on_detection_area_body_exited)

	if has_node("AttackCooldown"):
		$AttackCooldown.timeout.connect(_on_attack_cooldown_timeout)

	emit_signal("health_changed", health, min_health, max_health)
	emit_signal("mana_changed", mana,min_mana, max_mana)

func _physics_process(delta):
	emit_signal("health_changed", health, min_health, max_health)
	emit_signal("mana_changed", mana,min_mana, max_mana)
	if not is_alive:
		return
	if target_chase and target:
		if target.position.x > position.x:
			$DFBIdle.flip_h = true
			$DFBAttack.flip_h=true
			velocity.x = speed  
		elif target.position.x < position.x:
			$DFBIdle.flip_h = false
			$DFBAttack.flip_h=true
			velocity.x = -speed  
		if target.position.y > position.y:
			pass
	# Apply gravity
	velocity.y += GRAVITY * delta

	# Move horizontally only when in the air and player is detected
	if target and  is_on_floor():
		var direction = (target.global_position - global_position).normalized()
		$DFBIdle.flip_h = target.global_position.x < global_position.x
		$DFBAttack.flip_h = target.global_position.x < global_position.x
		velocity.x = direction.x * -speed/4 
	else:
		velocity.x = 0

	move_and_slide()

func _on_hurt_box_area_entered(hitbox: Hitbox) -> void:
	if is_alive:
		if attack_cooldown == true:
			health -= hitbox.get("Damage")
			knockbackAttackPlayer(hitbox.get("Knockback"))
			emit_signal("health_changed", health, min_health, max_health)
			emit_signal("mana_changed", mana,min_mana, max_mana)
			if health <= min_health:
				die()
			attack_cooldown == false
#			$AttackCooldown.start()
			if(mana>4):
				mana=mana-5
				var projectile = Bat_scene.instantiate()
				get_parent().add_child(projectile)

				# Get facing direction (not mouse position)
				var facing_right = not $DFBIdle.flip_h
				var direction_vector = Vector2.RIGHT if facing_right else Vector2.LEFT
				var direction_vector_up=Vector2.UP
				projectile.global_position = global_position + (direction_vector_up * 150)
			

func die():
	is_alive = false
	velocity = Vector2.ZERO
	$AnimationPlayer.play("Idle")
	await get_tree().create_timer(0.5).timeout
	queue_free()

func _on_attack_cooldown_timeout() -> void:
	if ((mana+1)>=max_mana):
		mana=max_mana
	else:
		mana=mana+6
	emit_signal("mana_changed", mana,min_mana,max_mana)
	print("hp="+str(health))
	print("mana="+str(mana))
	pass # Replace with function body.


func _on_damage_cooldown_timeout() -> void:
	if(mana>19):
				mana=mana-20
				var projectile = Rat_scene.instantiate()
				get_parent().add_child(projectile)

				# Get facing direction (not mouse position)
				var facing_right = not $DFBIdle.flip_h
				var direction_vector = Vector2.RIGHT if facing_right else Vector2.LEFT
				var direction_vector_up=Vector2.UP
				projectile.global_position = global_position + (direction_vector * 150)
	pass # Replace with function body.


func _on_detection_area_body_entered(body):
	if body.is_in_group("player"):
		target = body
		$DFBIdle.set_visible(false)
		$DFBAttack.set_visible(true)
		$AnimationPlayer.play("Attack")
		$HealthBar.set_visible(true)
		$DamageCooldown.start()



func _on_detection_area_body_exited(body):
	if body == target:
		target = null
		$DFBIdle.set_visible(true)
		$DFBAttack.set_visible(false)
		$AnimationPlayer.stop
		$DamageCooldown.stop()

func knockbackAttackPlayer(Force:int):
	velocity.y = -100*Force*3  # simulate bounce up
	velocity.x = -100*Force*3
#	var knockbackDirection= (-velocity)
#	velocity = knockbackDirection
#	print_debug(velocity)
#	print_debug(position)
	move_and_slide()
#	print_debug(position)
#	print_debug("    ")
#	print("")


func _on_hitbox_area_entered(hitbox: Hitbox) -> void:
	knockbackAttackPlayer(hitbox.get("Knockback"))
	pass # Replace with function body.
