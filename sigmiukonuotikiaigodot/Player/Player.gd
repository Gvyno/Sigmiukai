extends CharacterBody2D

@onready var animation = $AnimationPlayer
@export var knockbackPower: int = 25
signal health_changed(new_health,new_min_health,new_max_health)
signal mana_changed(new_mana,new_min_mana,new_max_mana)
var is_alive = true
var max_health=100
var min_health=0
var health =100
var max_mana=50
var min_mana=0
var mana =50

const SPEED = 200.0
const JUMP_VELOCITY = -400.0
const DASH_SPEED = 800.0  
const DASH_DURATION = 0.2  
const DASH_COOLDOWN = 0.5  

var is_casting = false
var has_fired_projectile = false  
var is_attacking = false
var is_dashing = false
var can_dash = true
var cast_timer = 0.0
var attack_timer = 0.0
var slash_timer = 0.0  
var dash_timer = 0.0  
var dash_cooldown_timer = 0.0  
var dash_direction = 1  
var is_hurt = false
var hurt_timer =0.3
enum AttackDirection { FORWARD, UP, DOWN }
var attack_direction = AttackDirection.FORWARD

var can_double_jump = false
var double_jump_timer = 0.0  
@export var DoubleJumpEnabled: bool = true  
@export var DashEnabled: bool = true  
@export var projectile_scene: PackedScene = preload("res://Player/Projectile.tscn")  


#regen timer
func _on_timer_timeout():
		if ((mana+10)>=max_mana):
			mana=max_mana
		else:
			mana=mana+10
		emit_signal("mana_changed", mana,min_mana,max_mana)
		#print("hp="+str(health))
		#print("mana="+str(mana))

func _physics_process(delta: float) -> void:
#	if is_on_wall() or is_on_floor():
#		var collision = get_last_slide_collision()
#		velocity = velocity.bounce(collision.get_normal()) * 0.8  # Adjust bounce strength
	emit_signal("health_changed", health, min_health,max_health)
	emit_signal("mana_changed", mana,min_mana,max_mana)
	if is_hurt:
		hurt_timer -= delta
		if hurt_timer <= 0:
			is_hurt = false
		else:
			move_and_slide()
			return
	if !is_alive:
		hurt_timer -= delta
		if hurt_timer <= 0:
			is_alive = false
		else:
			move_and_slide()
			return

	# **Freeze movement while casting**
	if is_casting:
		velocity = Vector2.ZERO  # Completely stop movement
		cast_timer -= delta

		# Fire projectile only once at 0.1s remaining
		if cast_timer <= 0.1 and not has_fired_projectile:
			has_fired_projectile = true
			fire_projectile()

		# End casting state
		if cast_timer <= 0:
			is_casting = false
			$SpriteCast.visible = false
			velocity.y = 0  # Start falling at **0 velocity**
		else:
			return  # Don't process movement while casting

	# Apply gravity normally when not on the ground
	if not is_on_floor() and not is_dashing:
		velocity += get_gravity() * delta

	# Reset double jump when landing
	if is_on_floor():
		can_double_jump = DoubleJumpEnabled  

	# Handle dash cooldown
	if not can_dash:
		dash_cooldown_timer -= delta
		if dash_cooldown_timer <= 0:
			can_dash = true

	# Handle dash movement
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false
			$SpriteDash.visible = false  
			velocity.x = 0  
			can_dash = false
			dash_cooldown_timer = DASH_COOLDOWN  
		else:
			velocity.x = dash_direction * DASH_SPEED
			move_and_slide()
			return

	# Handle attack cooldown
	if is_attacking:
		attack_timer -= delta
		if attack_timer <= 0:
			is_attacking = false
			$SpriteAttack.visible = false
			$SpriteSlash.visible = false  
			
		else:
			if attack_timer <= 0.3 and slash_timer > 0:
				slash_timer = 0
				trigger_slash()
			velocity.x = Input.get_axis("ui_left", "ui_right") * SPEED
			if Input.is_action_just_pressed("ui_accept"):
				if is_on_floor():
					velocity.y = JUMP_VELOCITY
			move_and_slide()
			return  

	# Handle jump 
	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		elif can_double_jump:
			velocity.y = JUMP_VELOCITY
			can_double_jump = false  
			$SpriteDoubleJump.visible = true
			hide_other_sprites("DoubleJump")
			animation.play("DoubleJump")
			flip_toward_facing()
			double_jump_timer = 0.2  

	# Handle dashing
	if DashEnabled and can_dash and Input.is_action_just_pressed("ui_shift") and not is_dashing:
		if(mana-10>=min_mana):
			mana=mana-10
			emit_signal("mana_changed", mana,min_mana,max_mana)
			start_dash()
		return

	# Handle casting input
	# Handle casting input (right mouse button)
	if Input.is_action_just_pressed("ui_right_mouse"):
		if mana - 20 >= min_mana:
			mana -= 20
			if((health-5)<=min_health):
				die()
			health -= 5
			emit_signal("health_changed", health, min_health, max_health)
			emit_signal("mana_changed", mana, min_mana, max_mana)

			is_casting = true
			cast_timer = 0.9  
			has_fired_projectile = false
			$SpriteCast.visible = true
			hide_other_sprites("Cast")
			animation.play("Cast")
			
			# Get the direction to the mouse
			var mouse_pos = get_global_mouse_position()
			var direction_to_mouse = (mouse_pos - global_position).normalized()

			# Flip the sprite based on the mouse position
			flip_sprites(direction_to_mouse.x < 0)

			# Update the facing direction of the attack
			flip_toward_facing()  # Update the attack to face the mouse direction
			return


	# Handle attacking
	if Input.is_action_just_pressed("ui_left_mouse"):
		is_attacking = true
		attack_timer = 0.6
		slash_timer = 0.3  

		# Determine attack direction using mouse position
		var mouse_pos = get_global_mouse_position()
		var to_mouse = (mouse_pos - global_position).normalized()

		if abs(to_mouse.y) > abs(to_mouse.x):
			if to_mouse.y < -0.5:
				attack_direction = AttackDirection.UP
			else:
				attack_direction = AttackDirection.DOWN
		else:
			attack_direction = AttackDirection.FORWARD

		# Flip player sprite based on horizontal direction
		if to_mouse.x < 0:
			flip_sprites(true)
		else:
			flip_sprites(false)

		# Choose animation and sprite based on movement
		if abs(velocity.x) > 0:
			hide_other_sprites("AttackWalking")
			$SpriteAttackWalking.visible = true
			animation.play("AttackWalking")
		else:
			hide_other_sprites("Attack")
			$SpriteAttack.visible = true
			animation.play("Attack")

		flip_toward_facing()  # Not toward mouse anymore
		return


	# Handle double jump sprite visibility
	if double_jump_timer > 0:
		double_jump_timer -= delta
		if double_jump_timer <= 0:
			$SpriteDoubleJump.visible = false  

	# Get input direction
	var direction := Input.get_axis("ui_left", "ui_right")

	# Allow movement in air
	if direction:
		
		if is_on_floor():
			$SpriteWalk.visible = true
			hide_other_sprites("Walk")
			animation.play("Walk")
			velocity.x = direction * SPEED
		else:
			velocity.x = direction * SPEED

		flip_sprites(direction < 0)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
		if is_on_floor():
			$SpriteIdle.visible = true
			hide_other_sprites("Idle")
			animation.play("Idle")
			velocity.x = move_toward(velocity.x, 0, SPEED)

	if not is_on_floor() and not $SpriteDoubleJump.visible:
		$SpriteJump.visible = true
		hide_other_sprites("Jump")
		animation.play("Float")

	move_and_slide()

func start_dash():
	is_dashing = true
	dash_timer = DASH_DURATION
	dash_direction = -1 if $SpriteIdle.flip_h else 1  
	velocity.x = dash_direction * DASH_SPEED
	hide_other_sprites("Dash")
	$SpriteDash.visible = true  
	animation.play("Dash")

func trigger_slash():
	hide_effect_sprites()
	$SecondaryAnimationPlayer.stop()

	var facing_left = $SpriteIdle.flip_h

	match attack_direction:
		AttackDirection.FORWARD:
			$SpriteSlash.visible = true
			$SecondaryAnimationPlayer.play("Slash")
			var offset_x = 35
			if facing_left:
				$SpriteSlash.global_position = global_position + Vector2(-offset_x, 0)
				$SpriteSlash.flip_h = true
			else:
				$SpriteSlash.global_position = global_position + Vector2(offset_x, 0)
				$SpriteSlash.flip_h = false


		AttackDirection.UP:
			$SpriteSlashUD.visible = true
			$SecondaryAnimationPlayer.play("SlashUD")
			$SpriteSlashUD.global_position = global_position + Vector2(0, -35)
			$SpriteSlashUD.flip_h = false
			$SpriteSlashUD.flip_v = facing_left 

		AttackDirection.DOWN:
			$SpriteSlashUD.visible = true
			$SecondaryAnimationPlayer.play("SlashUD")
			$SpriteSlashUD.global_position = global_position + Vector2(0, 35)

			if facing_left:
				$SpriteSlashUD.flip_h = true
				$SpriteSlashUD.flip_v = false
			else:
				$SpriteSlashUD.flip_h = true
				$SpriteSlashUD.flip_v = true


func fire_projectile():
	var projectile = projectile_scene.instantiate()
	get_parent().add_child(projectile)

	# Get facing direction (not mouse position)
	var facing_right = not $SpriteIdle.flip_h
	var direction_vector = Vector2.RIGHT if facing_right else Vector2.LEFT
	
	projectile.global_position = global_position + (direction_vector * 30)
	projectile.direction = direction_vector

func flip_toward_facing():
	flip_sprites($SpriteIdle.flip_h)  # Just use current facing direction

func flip_sprites(flip: bool):
	for sprite in ["Idle", "Walk", "Jump", "Cast", "Attack", "Dash", "DoubleJump", "AttackWalking"]:
		var node = get_node_or_null("Sprite" + sprite)
		if node:
			node.flip_h = flip
	var slash_node = get_node_or_null("SpriteSlash")
	if slash_node:
		slash_node.flip_h = flip
		slash_node.position.x = -20 if flip else 20

func hide_other_sprites(exception: String):
	for sprite in ["Death","Hurt" ,"Idle", "Walk", "Jump", "Cast", "Attack", "Slash", "Dash", "DoubleJump", "AttackWalking", "SlashUD"]:
		var node = get_node_or_null("Sprite" + sprite)
		if node and sprite != exception:
			node.visible = false

func hide_effect_sprites():
	for sprite in ["Slash", "SlashUD","Cast"]:
		var node = get_node_or_null("Sprite" + sprite)
		if node:
			node.visible = false

func _on_hitbox_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
	

func _on_hitbox_body_exited(body: Node2D) -> void:
	pass # Replace with function body.

	
'''
func _on_dogy_update_health() -> void:
	emit_signal("health_changed", health,min_health,max_health)


func _on_dogy_update_mana() -> void:
	emit_signal("mana_changed", mana,min_mana,max_mana)

func _on_bred_2_update_health() -> void:
	emit_signal("health_changed", health,min_health,max_health)



func _on_bred_2_update_mana() -> void:
	emit_signal("mana_changed", mana,min_mana,max_mana)



func _on_chems_update_health() -> void:
	emit_signal("health_changed", health,min_health,max_health)



func _on_chems_update_mana() -> void:
	emit_signal("mana_changed", mana,min_mana,max_mana)


func _on_food_item_update_health() -> void:
	emit_signal("health_changed", health, min_health,max_health)


func _on_bred_item_update_health() -> void:
	emit_signal("health_changed", health, min_health,max_health)


func _on_bred_item_update_mana() -> void:
	emit_signal("mana_changed", mana,min_mana,max_mana)

func _on_chems_item_update_health() -> void:
	emit_signal("health_changed", health, min_health,max_health)



func _on_chems_item_update_mana() -> void:
	emit_signal("mana_changed", mana,min_mana,max_mana)

func _on_dog_food_item_update_health() -> void:
	emit_signal("health_changed", health, min_health,max_health)



func _on_dog_food_item_update_mana() -> void:
	emit_signal("mana_changed", mana,min_mana,max_mana)
'''


func _on_hitbox_area_entered(area: Area2D) -> void:
	pass # Replace with function body.

func _on_hitbox_area_exited(area: Area2D) -> void:
	pass # Replace with function body.
func knockback():
	velocity.y = -300  # simulate bounce up
#	var knockbackDirection= (-velocity)
#	velocity = knockbackDirection
	print_debug(velocity)
	print_debug(position)
	move_and_slide()
	print_debug(position)
	print_debug("    ")



#func _on_hurt_box_itake_damage(damage: int) -> void:
#	pass # Replace with function body.


func _on_hurt_box_area_entered(hitbox: Hitbox) -> void:
#	knockback()
#	print("a skaud ?")
	if is_alive:
		is_hurt = true
		hurt_timer = 0.3
		$SpriteHurt.visible = true
		hide_other_sprites("Hurt")
		animation.play("Hurt")

		health=health-hitbox.get("Damage")
		emit_signal("health_changed",health,min_health,max_health)
		if health <= min_health:
			die()
		pass # Replace with function body.
	pass # Replace with function body.


func _on_hurt_box_body_entered(body: Node2D) -> void:
	if is_alive:
		knockback()
		is_hurt = true
		hurt_timer = 0.3
		$SpriteHurt.visible = true
		hide_other_sprites("Hurt")
		animation.play("Hurt")
		health=health-20
#		health=health-hitbox.get("Damage")
		emit_signal("health_changed",health,min_health,max_health)
		if health <= min_health:
			die()
		pass # Replace with function body.
	pass # Replace with function body.

func die():
	hide_effect_sprites()
	is_alive = false
	hurt_timer = 1
	$SpriteDeath.visible = true
	hide_other_sprites("Death")
	animation.play("Death")
#	print("Enemy died!")
	await get_tree().create_timer(1).timeout  
	get_tree().reload_current_scene()
	queue_free()  
#WIP might be useful later rn now it's here for more computer resource consumption :3
func _on_health_changed(new_health: Variant, new_min_health: Variant, new_max_health: Variant) -> void:
	if(health>new_health):
		hide_effect_sprites()
		$SpriteHurt.visible=true
		hide_other_sprites("Hurt" )
		animation.play("Hurt")
#		animation.advance(0)
	pass # Replace with function body.


func _on_head_area_body_entered(body: Node2D) -> void:
#	if body.is_in_group("emeny_rat"):  # Check if the object is the player
		if is_alive:
#			print("zdare")
			#knockback()
#			velocity.y = -velocity.y*knockbackPower  # Apply upward velocity to the player (bounce)
#			body.velocity.x = -body.velocity.x+1  # Apply knockback force to the player
#			body.velocity.y = -body.velocity.y  # Optionally, apply some vertical force to the player
#			body.GRAVITY=-2500
#			body.GRAVITY=2500
			# If the player is falling and is above the enemy, the enemy dies
#			if body.velocity.y > 0 and body.position.y < position.y:
				pass


func _on_respawn_pressed() -> void:
	die()
	pass # Replace with function body.


func _on_button_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.
