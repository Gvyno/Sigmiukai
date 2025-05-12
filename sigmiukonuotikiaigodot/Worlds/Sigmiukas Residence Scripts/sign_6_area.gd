extends Area2D

const lines: Array[String] = [
	"If you get damaged (you will get damaged)",
	"And you want to restore your health",
	"You can consume dropped items",
	"Different items restore...",
	" ...different ammounts of health",
	"I am giving you some of them for free",
	"But in the future...",
	"you'll need to explore to find them",
	"By the way... just so you know",
	"Bread restores 10 health, chems - 20, dog food - 30"
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
