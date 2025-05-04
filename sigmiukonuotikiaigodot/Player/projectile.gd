extends CharacterBody2D

@export var speed: float = 500.0
var direction: Vector2 = Vector2.ZERO  
var damage = 10
@onready var animation_player: AnimationPlayer = $AnimationPlayer  
@onready var sprite: Sprite2D = $Sprite2D  

func _ready() -> void:
	animation_player.play("Fired")  


func _physics_process(delta: float) -> void:
	$Hitbox.Damage=damage
	velocity = direction * speed  

	# Flip sprite based on direction
	if direction.x < 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false

	move_and_slide()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()  


func _on_timer_timeout() -> void:
	print("padabing")
	velocity = Vector2.ZERO  # Stop movement
	await get_tree().create_timer(0.25).timeout  # Wait for 1.5 seconds
	queue_free()  # Remove the enemy
	pass # Replace with function body.
