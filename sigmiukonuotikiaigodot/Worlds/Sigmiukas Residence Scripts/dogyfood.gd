extends Area2D
#@onready var chms: Sprite2D = $"../../Chems/Chms"
@onready var food_img: Sprite2D = $"../FoodImg"
const lines: Array[String] = [
]

var player_in_range := false

func _ready():
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)
	$PressELabelEatDogy.hide()  

func _process(delta):
	#if player_in_range and Input.is_action_just_pressed("interact"): 
	pass
		
		
		

var consumed = false

func _on_body_entered(body):
	if body.is_in_group("player") and not consumed:
		consumed = true
		if body.health + 10 >= body.max_health:
			body.health = body.max_health
		else:
			body.health += 10
		food_img.visible = false
#		Dogy_collision.disabled = true

func _on_body_exited(body):
	if body.is_in_group("player"):  
		player_in_range = false
		$PressELabelEatDogy.hide()
		if DialogueManager.is_dialogue_active:
			DialogueManager.end_dialogue()
