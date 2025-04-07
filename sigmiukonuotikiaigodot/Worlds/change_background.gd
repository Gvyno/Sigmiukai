extends Area2D

@export var new_background: PackedScene  # Assign a background scene in the Inspector
 

func _ready():
	var cave = $"../Cave"
	cave.visible = false
	cave.z_index = -10

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		var cave = $"../Cave"
		cave.visible = true
		cave.z_index = 10
