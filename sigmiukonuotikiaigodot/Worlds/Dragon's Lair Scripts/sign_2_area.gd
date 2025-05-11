extends Area2D

const lines: Array[String] = [
	"Oh and once again, I almost forgot...",
	"You have learnt the last possible move!",
	"Press SHIFT to use your DASH ability!",
	"It will greatly increase the distance which you can travel!",
	"Be aware that it also uses your mana!",
	"Now, cmon, test out your DASH!",
	"You can trust the arrow signs, they will tell you where to go.",
]

var player_in_range := false

func _ready():
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)

func _process(delta):
	if player_in_range and Input.is_action_just_pressed("interact"): 
		DialogueManager.start_dialogue(global_position, lines)

func _on_body_entered(body):
	if body.is_in_group("player"):  
		player_in_range = true

func _on_body_exited(body):
	if body.is_in_group("player"):  
		player_in_range = false
		if DialogueManager.is_dialogue_active:
			DialogueManager.end_dialogue()
