extends Area2D

const lines: Array[String] = [
	"As I have promised you before...",
	"You have unlocked a new ability - Cast!",
	"Press RIGHT MOUSE BUTTON to activate it!",
	"Be aware that it uses your mana tho...",
	"But the damage it does is worth it!",
	"Go on, try it out!"
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
