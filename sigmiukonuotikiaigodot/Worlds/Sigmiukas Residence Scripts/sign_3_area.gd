extends Area2D

const lines: Array[String] = [
	"You will learn many more different moves later on...",
	"Each new move will be awarded to you...",
	"once you enter a new world...",
	"Those new moves will help you traverse the land...",
	"and fight...",
	"But right now, you will have make do with what you've got...",
	"Go forward and reach another sign!"
]

func _ready():
	connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("player"):  
		DialogueManager.start_dialogue(global_position, lines)

func _on_body_exited(body):
	if body.is_in_group("player"):  
		if DialogueManager.is_dialogue_active:
			DialogueManager.end_dialogue()
