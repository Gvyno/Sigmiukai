extends Area2D

const lines: Array[String] = [
	"Hey there!",
	"I see you have already figured the movement.",
	"Good job!",
	"And if you somehow didn't...",
	"Then...",
	"You move left and right with A-D!",
	"Now use your precious knowledge...",
	"...and reach the next sign!",
	"GO GO GO!"
]

var player_in_range := false

func _ready():
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)
	$PressELabel.hide()  

func _process(delta):
	if player_in_range and Input.is_action_just_pressed("interact"): 
		DialogueManager.start_dialogue(global_position, lines)

func _on_body_entered(body):
	if body.is_in_group("player"):  
		player_in_range = true
		$PressELabel.show()

func _on_body_exited(body):
	if body.is_in_group("player"):  
		player_in_range = false
		$PressELabel.hide()
		if DialogueManager.is_dialogue_active:
			DialogueManager.end_dialogue()
