extends Area2D
#@onready var chms: Sprite2D = $"../../Chems/Chms"
@onready var food_img: Sprite2D = $"../FoodImg"

const lines: Array[String] = [
	"Eat",
	"Eat",
	"Eat",
	"you want!!!!!!!!!!!!!!!!!!!!!!!!!1!!!!!!!",
	"Eat",
	"Eat",
	"Eat",
	"GO GO GO!"
]

var player_in_range := false

func _ready():
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)
	$PressELabelEatChems.hide()  

func _process(delta):
	#if player_in_range and Input.is_action_just_pressed("interact"): 
	pass
		
		
		

var consumed = false
#I had no idea how to make it work with interactions so I improvised (hopefully for the better)
func _on_body_entered(body):
	$PressELabelEatChems.show()
	if body.is_in_group("player") and not consumed:
		consumed = true
		if body.health + 10 >= body.max_health:
			body.health = body.max_health
		else:
			body.health += 10
		food_img.visible = false
		

func _on_body_exited(body):
	if body.is_in_group("player"):  
		player_in_range = false
		$PressELabelEatChems.hide()
		if DialogueManager.is_dialogue_active:
			DialogueManager.end_dialogue()
