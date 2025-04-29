extends CharacterBody2D

@export var speed: float = 50
@export var damage: int = 10
@export var max_health: int = 250


var GRAVITY = 2055
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
var ROLLINTIMEOFF=false

var min_health = 0
var health = max_health
var max_mana = 50
var min_mana = 0
var mana = 50


var ROLLIN = true
var CHOMPING =true

var rollspeed =speed*2
var walkspeed =speed/2

func _ready():
	current_health = max_health
	mana=max_mana
	emit_signal("health_changed", health, min_health, max_health)
	emit_signal("mana_changed", mana,min_mana, max_mana)
	print(is_alive)
	
	$FTWIdle.visible = true
	$AnimationPlayer.play("Idle")

	$DetectionArea.body_entered.connect(_on_detection_area_body_entered)
	$DetectionArea.body_exited.connect(_on_detection_area_body_exited)

	if has_node("AttackCooldown"):
		$AttackCooldown.timeout.connect(_on_attack_cooldown_timeout)

	emit_signal("health_changed", health, min_health, max_health)
	emit_signal("mana_changed", mana,min_mana, max_mana)

func _physics_process(delta):
#	print(ROLLIN)
	emit_signal("health_changed", health, min_health, max_health)
	emit_signal("mana_changed", mana,min_mana, max_mana)
	if ROLLIN:
		speed=rollspeed
		GRAVITY=0
		$Hitbox.set_collision_layer_value(4,true)
		$HitBoxBash.set_collision_layer_value(4,false)
		$FTWBash.set_visible(false)
		$FTWIdle.set_visible(false)
		$FTWWalk.set_visible(false)
		$FTWRotate.set_visible(true)
	else:
		speed=walkspeed
		GRAVITY=2055
		$FTWRotate.set_visible(false)
		$Hitbox.set_collision_layer_value(4,false)
		if CHOMPING && not ROLLIN:
			$HitBoxBash.set_collision_layer_value(4,true)
			$FTWBash.set_visible(true)
		else:
			$FTWWalk.set_visible(true)
		$Rolling.start()
	
	if not is_alive:
		return
		'''
	if target_chase and target:
		if target.position.x > position.x:
			$FTWIdle.flip_h = false
			$DFBAttack.flip_h = false
			velocity.x = speed
		elif target.position.x < position.x:
			$FTWIdle.flip_h = true
			$DFBAttack.flip_h = true
			velocity.x = -speed
'''
		if target.position.y > position.y:
			pass
	# Apply gravity
	velocity.y += GRAVITY * delta
	move_and_slide()
	# Move horizontally only when in the air and player is detected
	if target:
		var direction = (target.global_position - global_position).normalized()
		velocity.x = direction.x * speed
		velocity.y = direction.y * speed
		$FTWIdle.flip_h = target.global_position.x > global_position.x
		$FTWRotate.flip_h = target.global_position.x > global_position.x
		$FTWBash.flip_h = target.global_position.x > global_position.x
		$FTWWalk.flip_h = target.global_position.x > global_position.x
		if(target.global_position.x > global_position.x):
			pass #todo lol

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
			attack_cooldown = false
			$AttackCooldown.start()
			

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
#	print("hp="+str(health))
#	print("mana="+str(mana))
	attack_cooldown=true
	pass # Replace with function body.


func _on_damage_cooldown_timeout() -> void:
	pass # Replace with function body.


func _on_detection_area_body_entered(body):
	if body.is_in_group("player"):
		target = body
		$FTWIdle.set_visible(false)
#		$DFBAttack.set_visible(true)
		$FTWWalk.set_visible(false)
		$FTWBash.set_visible(false)
		$FTWRotate.set_visible(true)
		$AnimationPlayer.play("Rotate")
		$HealthBar.set_visible(true)
		speed=speed*2
		$Rolling.start()
#		$DamageCooldown.start()



func _on_detection_area_body_exited(body):
	if body == target:
		target = null
		$FTWIdle.set_visible(true)
		$FTWRotate.set_visible(false)
#		$DFBAttack.set_visible(false)
		$AnimationPlayer.stop
		speed=speed/2
		$Rolling.stop()
#		$DamageCooldown.stop()

func knockbackAttackPlayer(Force:int):
	velocity.y = -100*Force*4  # simulate bounce up
	velocity.x = -100*Force*4
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


func _on_detection_area_bash_body_entered(body: Node2D) -> void:
		if body == target:
			CHOMPING=true
	#		target = body
			$FTWIdle.set_visible(false)
			$FTWWalk.set_visible(false)
			$FTWRotate.set_visible(false)
			$FTWBash.set_visible(true)
		#	$DFBAttack.set_visible(false)
	#		$AnimationPlayer.s

func _on_detection_area_bash_body_exited(body: Node2D) -> void:
		if body == target:
			CHOMPING=false
	#		target = body
			$FTWIdle.set_visible(false)
			$FTWWalk.set_visible(true)
			$FTWRotate.set_visible(false)
			$FTWBash.set_visible(false)
			#get_node("Hitbox/CollisionShape2D").disabled=true
			#get_node("HitBoxBash/CollisionShape2D").disabled=true

		#	$DFBAttack.set_visible(false)
	#		$AnimationPlayer.s


func _on_hit_box_bash_area_entered(area: Area2D) -> void:
	pass # Replace with function body.


func _on_hurt_box_shell_area_entered(hitbox: Hitbox) -> void:
	if is_alive:
		if attack_cooldown == true:
#			health -= hitbox.get("Damage")/3
#			knockbackAttackPlayer(hitbox.get("Knockback"))
			emit_signal("health_changed", health, min_health, max_health)
			emit_signal("mana_changed", mana,min_mana, max_mana)
			if health <= min_health:
				die()
			attack_cooldown = false
			$AttackCooldown.start()


func _on_detection_area_no_roll_body_entered(body: Node2D) -> void:	
	if body == target:
#		ROLLIN=false
		ROLLINTIMEOFF=true
#		target = body
		$FTWIdle.set_visible(false)
		$FTWWalk.set_visible(true)
		$FTWRotate.set_visible(false)
	#	$DFBAttack.set_visible(false)
#		$AnimationPlayer.s
#		speed=speed/2
#		$Rolling.stop()
#	$DamageCooldown.stop()


func _on_detection_area_no_roll_body_exited(body: Node2D) -> void:
	if body == target:
		ROLLIN=true
		ROLLINTIMEOFF=false
#		target = null
		$FTWIdle.set_visible(false)
		$FTWWalk.set_visible(false)
		$FTWRotate.set_visible(true)
	#	$DFBAttack.set_visible(false)
#		$AnimationPlayer.stop
#		speed=speed*2
		$Rolling.start()
#	$DamageCooldown.stop()


func _on_rolling_timeout() -> void:
	if(ROLLINTIMEOFF):
		ROLLIN=false
	print("lol")
	
