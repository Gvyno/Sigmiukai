extends CharacterBody2D

@export var speed: float = 150.0
@export var damage: int = 10
@export var max_health: int = 30

var current_health: int
var target: Node2D = null
var attack_cooldown := true
var is_alive := true

#var speed = 150  # Speed at which the enemy moves
var player_chase = false  # Whether the enemy is chasing the player
var player = null  # Reference to the player node
#var is_alive = true  # If the enemy is alive
const GRAVITY = 2055  # Gravity strength (adjust as needed)
const JUMP_VELOCITY = -400.0  # Jump force
signal health_changed(new_health,new_min_health,new_max_health)
#var max_health=80
var min_health=0
var health =max_health
var max_mana=50
var min_mana=0
var mana =50
var enemy_attackcooldown =true
# Health-related signals
#signal health_changed(new_health)

func _ready():
	current_health = max_health
	print(is_alive)
	# Play idle animation
	$SpriteIdle.visible = true
	$AnimationPlayer.play("Idle")

	# Connect detection signals
	$DetectionArea.body_entered.connect(_on_detection_body_entered)
	$DetectionArea.body_exited.connect(_on_detection_body_exited)
	
	# Connect HurtBox collision signal
#	if has_node("HurtBox"):
#		$HurtBox.body_entered.connect(_on_hurtbox_body_entered)
		
	# Connect attack cooldown timer
	if has_node("AttackCooldown"):
		$AttackCooldown.timeout.connect(_on_attack_cooldown_timeout)

	# Emit the initial health signal
	emit_signal("health_changed",health,min_health,max_health)
	pass

func _physics_process(delta):
	if not is_alive:
		return

	if target:
		var direction = (target.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()

		# Flip sprite to face player
		$SpriteIdle.flip_h = target.global_position.x > global_position.x
	else:
		velocity = Vector2.ZERO

func _on_detection_body_entered(body):
	if body.is_in_group("player"):
		target = body

func _on_detection_body_exited(body):
	if body == target:
		target = null

func _on_hurt_box_area_entered(hitbox: Hitbox) -> void:
	if is_alive:
#		print("Something entered the enemy hitbox:", hitbox)
#		print(hitbox.name)
#		print(hitbox.get_path())
		if(enemy_attackcooldown==true):
			health=health-hitbox.get("Damage")
			emit_signal("health_changed",health,min_health,max_health)
			if health <= min_health:
				die()
			enemy_attackcooldown==false
			$AttackCooldown.start()
	pass # Replace with function body.

# Handling the enemy's death
func die():
	is_alive = false
	velocity = Vector2.ZERO
	$AnimationPlayer.play("Idle")
	await get_tree().create_timer(0.5).timeout
	queue_free()

# Cooldown reset when timer completes
func _on_attack_cooldown_timeout():
	attack_cooldown = true
