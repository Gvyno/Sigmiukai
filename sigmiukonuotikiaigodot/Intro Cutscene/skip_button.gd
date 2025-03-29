extends Button

func _ready():
	connect("pressed", _on_skip_pressed)

func _on_skip_pressed():
	get_tree().change_scene_to_file("res://Worlds/Sigmiukas Residence.tscn")
