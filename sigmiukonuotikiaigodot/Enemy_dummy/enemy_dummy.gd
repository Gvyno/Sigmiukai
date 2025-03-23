extends CharacterBody2D

var health = 3  
var is_alive = true

func _ready():
	$Hitbox.connect("body_entered", _on_hitbox_body_entered)
	
func _physics_process(delta: float) -> void:
	$AnimatedSprite2D.play("jump")

func take_damage(amount: int):
	if is_alive:
		health -= amount  
		print("Enemy took damage! Remaining health:", health)
		
		if health <= 0:
			die()

func die():
	is_alive = false
	print("Enemy died!")
	await get_tree().create_timer(0.5).timeout  
	queue_free()  

func _on_hitbox_body_entered(body: Node2D) -> void:
	print("Something entered the enemy hitbox:", body.name)  # Debug print
	if body.is_in_group("attack_hitbox"): 
		print("Enemy got hit by player attack!")
		take_damage(1)


func _on_hitbox_area_entered(area: Area2D) -> void:
	print("Something entered the enemy hitbox:", area)  # Debug print
	if area.is_in_group("attack_hitbox"): 
		print("Enemy got hit by player attack!")
		take_damage(1)
		 # Replace with function body.
#GitHub is a stupid
