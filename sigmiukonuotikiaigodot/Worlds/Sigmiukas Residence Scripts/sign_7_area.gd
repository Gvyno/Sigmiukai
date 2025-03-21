extends Area2D

const lines: Array[String] = [
	"I have nothing more to teach you...",
	"I hope that what you have learned",
	"Will come in handy in the future",
	"Now go forth and explore",
	"There is a lemon waiting for you",
	"Far far away..."
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
