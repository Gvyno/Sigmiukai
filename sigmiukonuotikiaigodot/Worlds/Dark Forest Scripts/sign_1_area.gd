extends Area2D

const lines: Array[String] = [
	"It would be foolish to go back now..."
]

var player_in_range := false

func _ready():
#	connect("body_entered", _on_body_entered)
	pass

func _on_body_entered(body):
	if body.is_in_group("player"):  
		DialogueManager.start_dialogue(global_position, lines)

func _on_body_exited(body):
	if body.is_in_group("player"):  
		if DialogueManager.is_dialogue_active:
			DialogueManager.end_dialogue()
