extends Area2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var food_img: Sprite2D = $food_img
@onready var animation = $AnimationPlayer
signal update_health()
signal update_mana()
signal update_damage()
@export var AddDamageAmount=5
var player_in_range := false
var consumed = false

func _ready():
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)
	animation.play("Idle")

func _on_body_entered(body):
	if body.is_in_group("player") and not consumed:
		'''
		if body.health + 20 >= body.max_health+20:
			body.max_health=body.max_health+20
			body.health = body.max_health
		else:
			body.max_health=body.max_health+20
			body.health += 20
		if body.mana + 20 >= body.max_mana+20:
			body.max_mana=body.max_mana+20
			body.mana = body.max_mana
		else:
			body.max_mana=body.max_mana+20
			body.mana += 20
		'''
		body.damage=body.damage+AddDamageAmount;
		consumed = true
		food_img.visible=false
		collision_shape_2d.disabled=true
		collision_shape_2d.visible=false
	emit_signal("update_damage")
	emit_signal("update_health")

func _on_body_exited(body):
	if body.is_in_group("player"):  
		player_in_range = false
		if DialogueManager.is_dialogue_active:
			DialogueManager.end_dialogue()
