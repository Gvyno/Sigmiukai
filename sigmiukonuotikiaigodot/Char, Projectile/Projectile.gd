extends CharacterBody2D

@export var speed: float = 500.0
var direction: Vector2 = Vector2.ZERO  # Now stores a vector instead of an int
@onready var animation_player: AnimationPlayer = $AnimationPlayer  # Reference to AnimationPlayer

func _ready() -> void:
	animation_player.play("Fired")  # Play the animation when the projectile is created

func _physics_process(delta: float) -> void:
	velocity = direction * speed  # Move in the assigned direction
	move_and_slide()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()  # Delete projectile when off-screen
