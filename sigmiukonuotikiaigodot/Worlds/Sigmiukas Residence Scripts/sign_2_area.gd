extends Area2D

const lines: Array[String] = [
	"The world we live in...",
	"...requires a lot of agility.",
	"That's why I am teaching you how to jump!",
	"Press SPACE to jump!",
	"And traverse this rock pile",
	"to reach another sign."
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
