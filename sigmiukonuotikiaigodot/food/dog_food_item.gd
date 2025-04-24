extends Area2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var food_img: Sprite2D = $food_img
@onready var animation = $AnimationPlayer
signal update_health()
signal update_mana()


var player_in_range := false
var consumed = false

func _ready():
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)
	animation.play("Dogy")

func _on_body_entered(body):
	if body.is_in_group("player") and not consumed:
		consumed = true
		if body.health + 10 >= body.max_health:
			body.health = body.max_health
		else:
			body.health += 10
		food_img.visible=false
		collision_shape_2d.disabled=true
	emit_signal("update_health")

func _on_body_exited(body):
	if body.is_in_group("player"):  
		player_in_range = false
		if DialogueManager.is_dialogue_active:
			DialogueManager.end_dialogue()
