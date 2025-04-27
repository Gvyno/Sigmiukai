extends CharacterBody2D

var speed = 10#150  # Speed at which the enemy moves
var player_chase = false  # Whether the enemy is chasing the player
var player = null  # Reference to the player node
var is_alive = true  # If the enemy is alive
const GRAVITY = 100  # Gravity strength (adjust as needed)
const JUMP_VELOCITY = -400.0  # Jump force
signal health_changed(new_health,new_min_health,new_max_health)
var max_health=80
var min_health=0
var health =80
var max_mana=50
var min_mana=0
var mana =50
var enemy_attackcooldown =true
func _ready():
	emit_signal("health_changed",health,min_health,max_health)
	pass
	
# This function will be triggered when the player enters the Area2D
func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):  # Check if the object is the player
		#print("Player entered detection area!")  # Debugging message
		player = body  # Assign the player node
		player_chase = true  # Start chasing the player
		

# This function will be triggered when the player leaves the Area2D
func _on_detection_area_body_exited(body: Node2D) -> void:
	if body == player:
		#print("Player exited detection area!")  # Debugging message
		player = null  # Clear the player reference
		player_chase = false  # Stop chasing the player
	

# This function handles the movement and chasing logic

func _physics_process(delta: float) -> void:
	# Apply gravity when not on the floor
#	if not is_on_floor():
#		velocity.y += GRAVITY * delta
	if player_chase and player:
		if player.position.x > position.x:
			$AnimatedSprite2D.flip_h = true
			velocity.x = speed  
		elif player.position.x < position.x:
			$AnimatedSprite2D.flip_h = false
			velocity.x = -speed  

		$AnimatedSprite2D.play("walk")
		move_and_slide()
	else:
		$AnimatedSprite2D.play("idle")


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
		if(enemy_attackcooldown==true):
			knockbackAttackPlayer()
			health=health-hitbox.get("Damage")
			emit_signal("health_changed",health,min_health,max_health)
			if health <= min_health:
				die()
			enemy_attackcooldown==false
			$AttackCooldown.start()
	pass # Replace with function body.


func _on_attack_cooldown_timeout() -> void:
	enemy_attackcooldown = true

func knockbackTakeDamage():
	velocity.y = -500 # simulate bounce up
	velocity.x = -500  
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
