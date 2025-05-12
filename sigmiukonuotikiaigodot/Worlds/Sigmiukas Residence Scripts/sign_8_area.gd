extends Area2D

const lines: Array[String] = [
	"Lastly, the most valuables items are...",
	"Stat increase items!",
	"Health Hearth - increases your max health",
	"Mana Bottle - increases your max mana",
	"Bloody Sword - increases your max damage",
	"Without collecting these items...",
	"Your journey will be doomed",
	"I am not even giving you these items now...",
	"You'll have to find them yourself!",
	"Each world contains one of each of these items!",
	"Therefore, you'll have to explore the world carefully...",
	"Try to enter every possible area...",
	"And search for these items!"
]

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
