extends Area2D

const lines: Array[String] = [
	"Great...!",
	"Now you have managed to break the ice...",
	"And fall into what seems like hell...",
	"You must be careful...",
	"This place is covered in fire and lava...",
	"It will damage you, better avoid it at all costs!",
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
