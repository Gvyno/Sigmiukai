extends Area2D

const lines: Array[String] = [
	"Many things in this world can damage you...",
	"One of those things are spikes!",
	"Make sure to jump over them...",
	"Or they will damage you...",
	"Go on, traverse the land and reach the other sign!",
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
