extends Area2D

const lines: Array[String] = [
	"Hey kid",
	"I have some candy in my van",
	"Do you want some :) ....?",
	"Show me your feet"
]

func _ready():
	connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("player"):  # Ensure the player is in a specific group
		DialogueManager.start_dialogue(global_position, lines)

func _on_body_exited(body):
	if body.is_in_group("player"):  # Ensure it only triggers for the player
		if DialogueManager.is_dialogue_active:
			DialogueManager.end_dialogue()
