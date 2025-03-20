extends Area2D

const lines: Array[String] = [
	"Almost forgot to mention",
	"You can also DOUBLE JUMP!",
	"Just press SPACE while midair",
	"Btw, beware of spikes",
	"They'll deal damage if stepped on."
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
