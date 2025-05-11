extends Control

@onready var cutscene = $CutScene  
@onready var animation_player = cutscene.get_node("AnimationPlayer")

func _ready() -> void:
	animation_player.animation_finished.connect(_on_animation_finished)
	cutscene.visible = false  

func _process(delta: float) -> void:
	pass

func _on_start_pressed() -> void:
	cutscene.visible = true  
	animation_player.play("Intro")  

	$VBoxContainer/Button.hide()
	$VBoxContainer/Button3.hide()

func _on_exit_3_pressed() -> void:
	get_tree().quit()

func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Intro":  
		get_tree().change_scene_to_file("res://Worlds/Sigmiukas Residence.tscn")
