extends CharacterBody2D


func _physics_process(delta: float) -> void:
	# Add the gravity.
	$AnimatedSprite2D.play("walk")
