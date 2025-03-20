extends CharacterBody2D

@export var speed: float = 500.0
var direction: Vector2 = Vector2.ZERO  

@onready var animation_player: AnimationPlayer = $AnimationPlayer  
@onready var sprite: Sprite2D = $Sprite2D  

func _ready() -> void:
	animation_player.play("Fired")  

func _physics_process(delta: float) -> void:
	velocity = direction * speed  

	# Flip sprite based on direction
	if direction.x < 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false

	move_and_slide()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()  
