extends CharacterBody2D

@onready var animation = $AnimationPlayer
const SPEED = 200.0
const JUMP_VELOCITY = -400.0

var is_casting = false
var is_attacking = false
var cast_timer = 0.0
var attack_timer = 0.0

@export var projectile_scene: PackedScene = preload("res://Char, Projectile//Projectile.tscn")  # Load projectile scene

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle casting cooldown
	if is_casting:
		cast_timer -= delta
		if cast_timer <= 0:
			is_casting = false
			$SpriteCast.visible = false
		else:
			return

	# Handle attack cooldown
	if is_attacking:
		attack_timer -= delta
		if attack_timer <= 0:
			is_attacking = false
			$SpriteAttack.visible = false
		else:
			return

	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Handle casting
	if Input.is_action_just_pressed("ui_right_mouse") and is_on_floor():
		is_casting = true
		cast_timer = 0.5
		$SpriteCast.visible = true
		$SpriteIdle.visible = false
		$SpriteRun.visible = false
		$SpriteWalk.visible = false
		$SpriteJump.visible = false
		$SpriteAttack.visible = false
		animation.play("Cast")

		# Flip character towards mouse
		flip_toward_mouse()

		# Fire projectile
		fire_projectile()
		return

	# Handle attacking
	if Input.is_action_just_pressed("ui_left_mouse") and is_on_floor():
		is_attacking = true
		attack_timer = 0.5
		$SpriteAttack.visible = true
		$SpriteIdle.visible = false
		$SpriteRun.visible = false
		$SpriteWalk.visible = false
		$SpriteJump.visible = false
		$SpriteCast.visible = false
		animation.play("Attack")

		# Flip character towards mouse
		flip_toward_mouse()
		return

	# Get input direction
	var direction := Input.get_axis("ui_left", "ui_right")

	if is_on_floor():
		if direction:
			if Input.is_action_pressed("ui_shift"):
				$SpriteRun.visible = true
				$SpriteIdle.visible = false
				$SpriteWalk.visible = false
				$SpriteJump.visible = false
				$SpriteCast.visible = false
				$SpriteAttack.visible = false
				animation.play("Run")
				velocity.x = direction * SPEED * 2
			else:
				$SpriteWalk.visible = true
				$SpriteIdle.visible = false
				$SpriteRun.visible = false
				$SpriteJump.visible = false
				$SpriteCast.visible = false
				$SpriteAttack.visible = false
				animation.play("Walk")
				velocity.x = direction * SPEED
		else:
			$SpriteIdle.visible = true
			$SpriteRun.visible = false
			$SpriteWalk.visible = false
			$SpriteJump.visible = false
			$SpriteCast.visible = false
			$SpriteAttack.visible = false
			animation.play("Idle")
			velocity.x = move_toward(velocity.x, 0, SPEED)
	else:
		# Ensure jump animation plays when in the air
		$SpriteJump.visible = true
		$SpriteWalk.visible = false
		$SpriteIdle.visible = false
		$SpriteRun.visible = false
		$SpriteCast.visible = false
		$SpriteAttack.visible = false
		animation.play("Float")

	# Handle sprite flipping when moving
	if direction > 0:
		flip_sprites(false)
	elif direction < 0:
		flip_sprites(true)

	move_and_slide()

func fire_projectile():
	var projectile = projectile_scene.instantiate()  # Create a projectile instance
	get_parent().add_child(projectile)  # Add projectile to the scene

	# Get mouse position in world coordinates
	var mouse_position = get_global_mouse_position()

	# Calculate the direction vector from player to mouse
	var direction_vector = (mouse_position - global_position).normalized()

	# Set the projectile's position slightly offset from the player
	projectile.global_position = global_position + (direction_vector * 30)

	# Assign direction to the projectile
	projectile.direction = direction_vector  # Pass direction as a Vector2

func flip_toward_mouse():
	var mouse_position = get_global_mouse_position()
	var facing_right = mouse_position.x > global_position.x
	flip_sprites(not facing_right)

func flip_sprites(flip: bool):
	$SpriteIdle.flip_h = flip
	$SpriteWalk.flip_h = flip
	$SpriteRun.flip_h = flip
	$SpriteJump.flip_h = flip
	$SpriteCast.flip_h = flip
	$SpriteAttack.flip_h = flip
