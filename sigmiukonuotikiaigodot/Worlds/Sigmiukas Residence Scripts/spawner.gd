extends Node2D


var player_scene = preload("res://Player/player.tscn")
var player = null
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	if player ==null:
		var new_obj = player_scene.instantiate()
		new_obj.position = position
		get_parent().add_child(new_obj)
		player= new_obj
	pass
