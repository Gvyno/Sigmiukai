extends CharacterBody2D
signal health_changed(new_health,new_min_health,new_max_health)
var is_alive = true
var max_health=1000
var min_health=0
var health =max_health
var max_mana=50
var min_mana=0
var mana =50
func _ready():
	emit_signal("health_changed",health,min_health,max_health)
	pass
	
func _physics_process(delta: float) -> void:
	$AnimatedSprite2D.play("jump")
'''
func take_damage(amount: int):
	if is_alive:
		health -= amount  
		print("Enemy took damage! Remaining health:", health)
		
		if health <= 0:
			die()
'''
#man im ded
func die():
	is_alive = false
	print("Enemy died!")
	await get_tree().create_timer(0.5).timeout  
	queue_free()  
'''
func _on_hitbox_body_entered(body: Node2D) -> void:
	print("Something entered the enemy hitbox:", body.name)  # Debug print
	if body.is_in_group("attack_hitbox"): 
		print("Enemy got hit by player attack!")
		#take_damage(1)

func _on_hitbox_area_entered(area: Area2D) -> void:
	print("Something entered the enemy hitbox:", area)  # Debug print
	if area.is_in_group("attack_hitbox"): 
		print("Enemy got hit by player attack!")
		#take_damage(1)
		 # Replace with function body.
#GitHub is a stupid
'''
func enemy():
	pass
func take_damage() ->void:
	#print("AUCH")
	pass


func _on_hurt_box_itake_damage(damage: int) -> void:
#	print("AAAUAUUAUAUAUA")
	pass # Replace with function body.

func _on_hurt_box_area_entered(hitbox: Hitbox) -> void:
	if is_alive:
#			print("Something entered the enemy hitbox:", hitbox)
#			print(hitbox.name)
#			print(hitbox.get_path())
	#		if(hitbox.get):
				
			health=health-hitbox.get("Damage")
			emit_signal("health_changed",health,min_health,max_health)
			if health <= min_health:
				die()
	pass # Replace with function body.
