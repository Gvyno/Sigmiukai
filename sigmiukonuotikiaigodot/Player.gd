extends CharacterBody2D

@onready var animation = $AnimationPlayer

@onready var health_bar = $HealthBar
@onready var mana_bar =$ManaBar
var hp =100
var mana =100

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

var can_double_jump = false
var double_jump_timer = 0.0  
@export var DoubleJumpEnabled: bool = true  
@export var DashEnabled: bool = true  
@export var projectile_scene: PackedScene = preload("res://Projectile.tscn")  

func _physics_process(delta: float) -> void:
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
		
		hp-=1
		mana+=1
		health_bar.value=hp
		mana_bar.value=mana
		
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		elif can_double_jump:
			velocity.y = JUMP_VELOCITY
			can_double_jump = false  
			$SpriteDoubleJump.visible = true
			hide_other_sprites("DoubleJump")
			animation.play("DoubleJump")
			flip_toward_mouse()
			double_jump_timer = 0.2  

	# Handle dashing
	if DashEnabled and can_dash and Input.is_action_just_pressed("ui_shift") and not is_dashing:
		start_dash()
		return

	# Handle casting input
	if Input.is_action_just_pressed("ui_right_mouse"):
		is_casting = true
		cast_timer = 0.9  
		has_fired_projectile = false  
		$SpriteCast.visible = true
		hide_other_sprites("Cast")
		animation.play("Cast")
		flip_toward_mouse()
		return

	# Handle attacking
	if Input.is_action_just_pressed("ui_left_mouse"):
		is_attacking = true
		attack_timer = 0.6
		slash_timer = 0.3  
		$SpriteAttack.visible = false
		$SpriteAttackWalking.visible = false

		if abs(velocity.x) > 0:  
			hide_other_sprites("AttackWalking")
			$SpriteAttackWalking.visible = true
			animation.play("AttackWalking")
		else:
			hide_other_sprites("Attack")
			$SpriteAttack.visible = true
			animation.play("Attack")

		flip_toward_mouse()
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
		
		hp-=1
		mana+=1
		health_bar.value=hp
		mana_bar.value=mana
		
		if is_on_floor():
			$SpriteWalk.visible = true
			hide_other_sprites("Walk")
			animation.play("Walk")
			velocity.x = direction * SPEED
		else:
			velocity.x = direction * SPEED

		flip_sprites(direction < 0)
	else:
		
		mana-=1
		hp+=1
		health_bar.value=hp
		mana_bar.value=mana
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
	$SpriteSlash.visible = true
	$SecondaryAnimationPlayer.stop()
	$SecondaryAnimationPlayer.play("Slash")
	
	var offset_x = 35
	if $SpriteAttack.flip_h or $SpriteAttackWalking.flip_h:
		$SpriteSlash.global_position = global_position + Vector2(-offset_x, 0)
		$SpriteSlash.flip_h = true
	else:
		$SpriteSlash.global_position = global_position + Vector2(offset_x, 0)
		$SpriteSlash.flip_h = false

func fire_projectile():
	var projectile = projectile_scene.instantiate()
	get_parent().add_child(projectile)

	# Get facing direction (not mouse position)
	var facing_right = not $SpriteIdle.flip_h
	var direction_vector = Vector2.RIGHT if facing_right else Vector2.LEFT
	
	projectile.global_position = global_position + (direction_vector * 30)
	projectile.direction = direction_vector

func flip_toward_mouse():
	var mouse_position = get_global_mouse_position()
	var facing_right = mouse_position.x > global_position.x
	flip_sprites(not facing_right)

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
	for sprite in ["Idle", "Walk", "Jump", "Cast", "Attack", "Slash", "Dash", "DoubleJump", "AttackWalking"]:
		var node = get_node_or_null("Sprite" + sprite)
		if node and sprite != exception:
			node.visible = false
