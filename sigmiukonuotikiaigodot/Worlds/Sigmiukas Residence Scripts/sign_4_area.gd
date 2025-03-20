extends Area2D

const lines: Array[String] = [
	"The last move you need to learn is",
	"DASH!",
	"Press SHIFT to activate DASH",
	"You can do it midair aswell",
	"Now combine all you knowledge",
	"to complete this huge jump!"
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
