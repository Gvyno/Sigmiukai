extends CharacterBody2D

signal health_changed(new_health,new_min_health,new_max_health)
var enemy_DamageCooldown =true

var speed = 100#150  # Speed at which the enemy moves

var player_chase = false  # Whether the enemy is chasing the player
var player = null  # Reference to the player node
var is_alive = true  # If the enemy is alive

const GRAVITY = 2055
const JUMP_VELOCITY = -200.0
var knockback


var max_health=80
var min_health=0
var health =80
var max_mana=50
var min_mana=0
var mana =50

func _ready():
	emit_signal("health_changed",health,min_health,max_health)
	if has_node("JumpTimer"):
		$JumpTimer.timeout.connect(_on_jump_timer_timeout)
	pass
	
# This function will be triggered when the player enters the Area2D
func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):  # Check if the object is the player
		#print("Player entered detection area!")  # Debugging message
		player = body  # Assign the player node
		player_chase = true  # Start chasing the player
		$JumpTimer.start()
		

# This function will be triggered when the player leaves the Area2D
func _on_detection_area_body_exited(body: Node2D) -> void:
	if body == player:
		#print("Player exited detection area!")  # Debugging message
		player = null  # Clear the player reference
		player_chase = false  # Stop chasing the player
	

# This function handles the movement and chasing logic

func _physics_process(delta: float) -> void:
	# Apply gravity when not on the floor
	if not is_on_floor():
		velocity += get_gravity() * delta
#		velocity.y += GRAVITY * delta
	if player_chase and player:
		if player.position.x > position.x:
			$AnimatedSprite2D.flip_h = true
			velocity.x = speed  
		elif player.position.x < position.x:
			$AnimatedSprite2D.flip_h = false
			velocity.x = -speed  
		if player.position.y > position.y:
			pass
#			$AnimatedSprite2D.flip_h = true
#			velocity.y = JUMP_VELOCITY  
#			$AnimatedSprite2D.flip_h = false
#			velocity.y = -JUMP_VELOCITY

		$AnimatedSprite2D.play("walk")
		move_and_slide()
	else:
		$AnimatedSprite2D.play("idle")
		# On the rat:



func die():
	if not is_alive:
		return  # Prevent multiple death calls

	is_alive = false  
	velocity = Vector2.ZERO  # Stop movement
	
	# Flip die animation to match walking direction
	$AnimatedSprite2D.flip_h = $AnimatedSprite2D.flip_h  

	$AnimatedSprite2D.stop()  # Stop all animations
	$AnimatedSprite2D.play("die")  # Play the death animation


	await get_tree().create_timer(0.25).timeout  # Wait for 1.5 seconds
	queue_free()  # Remove the enemy



func _on_head_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):  # Check if the object is the player
		if is_alive:
			# If the player is falling and is above the enemy, the enemy dies
			if body.velocity.y > 0 and body.position.y < position.y:
				print("Player jumped on enemy! CRITICAL HIT.")
				health=health-50
				knockbackTakeHeadKnockback()
				emit_signal("health_changed",health,min_health,max_health)
				if health <= min_health:
					die()
#				velocity.y = -400  # Apply upward velocity to the player (bounce)
			else:
				# If the player hits the enemy from the side, knockback the player
				print("Player hit the enemy from the side!")
#				body.velocity.x = -150  # Apply knockback force to the player
#				body.velocity.y = -200  # Optionally, apply some vertical force to the player
#				velocity.x = -150  # Apply knockback force to the player
#				velocity.y = -200  # Optionally, apply some vertical force to the player
func enemy():
	pass

func _on_hurt_box_area_entered(hitbox: Hitbox) -> void:
	if is_alive:
#			print("Something entered the enemy hitbox:", hitbox)
#			print(hitbox.name)
#			print(hitbox.get_path())
		if(enemy_DamageCooldown==true):
			#get hitbox str
			health=health-hitbox.get("Damage")
			
			knockbackAttackPlayer(hitbox.get("Knockback"))
			emit_signal("health_changed",health,min_health,max_health)
			if health <= min_health:
				die()
			enemy_DamageCooldown=false
			$DamageCooldown.start()
	pass # Replace with function body.


func _on_attack_cooldown_timeout() -> void:
#	print("ticktock")
	enemy_DamageCooldown = true

func knockbackTakeHeadKnockback():
	velocity.y = -100*5  # simulate bounce up
	velocity.x = -100*5 
#	var knockbackDirection= (-velocity)
#	velocity = knockbackDirection
#	print_debug(velocity)
#	print_debug(position)
#	else:
#		velocity=Vector2(-force *2,-force*up_force)
#	velocity.y = -150 # simulate bounce up
#	velocity.x = -150  
#	var knockbackDirection= (-velocity)
#	velocity = knockbackDirection
#	print_debug(velocity)
#	print_debug(position)
	move_and_slide()
#	print_debug(position)
#	print_debug("    ")
	print("OWKNOCKEDBYPLAYER!")

func knockbackAttackPlayer(Force:int):
	velocity.y = -100*Force  # simulate bounce up
	velocity.x = -100*Force 
#	var knockbackDirection= (-velocity)
#	velocity = knockbackDirection
#	print_debug(velocity)
#	print_debug(position)
	move_and_slide()
#	print_debug(position)
#	print_debug("    ")
#	print("")

#for future
func _on_hitbox_area_entered(hitbox: Hitbox) -> void:
#	if(enemy_DamageCooldown==true):
#		knockbackAttackPlayer()
#		health=health-hitbox.get("Damage")
#		emit_signal("health_changed",health,min_health,max_health)
#	if health <= min_health:
#		die()
#	enemy_DamageCooldown=false
#	$DamageCooldown.start()
	pass


func _on_jump_timer_timeout():
	if player and is_on_floor():
		velocity.y = JUMP_VELOCITY


func _on_damage_cooldown_timeout() -> void:
	pass # Replace with function body.
