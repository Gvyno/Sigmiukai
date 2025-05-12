extends Area2D

const lines: Array[String] = [
	"By the way!",
	"If you haven't noticed yet...",
	"You have once again learnt a new move!",
	"That big ahh tree taught you how to...",
	"DOUBLE JUMP!",
	"Now no big obstacle shall be a problem!",
	"Simple press SPACE will mid air to double jump",
	"Cmon, try it out!"
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
