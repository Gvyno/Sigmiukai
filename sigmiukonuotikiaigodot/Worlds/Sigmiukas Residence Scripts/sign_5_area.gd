extends Area2D

const lines: Array[String] = [
	"Now that you can move",
	"Let's learn how to defend and attack",
	"Press MOUSE1 to do a MELEE ATTACK",
	"The slash indicates your hit range",
	"If you don't want to get up close and personal",
	"You can use RANGED ATTACKS!",
	"Press MOUSE2 to cast a ranged projectile",
	"Go practice your new moves",
	"Next to you there is DUMMY",
	"Show him what you've learned!"
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
