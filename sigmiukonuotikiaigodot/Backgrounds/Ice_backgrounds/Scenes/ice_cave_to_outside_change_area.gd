extends Area2D

# Hardcoding the scene tree path for the background groups
var outside_group : ParallaxBackground
var cave_group : ParallaxBackground
@export var collision_size : Vector2 = Vector2(100, 50) # Default size
@onready var collision_shape = $CollisionShape2D

func _ready():
	
	# Get the nodes directly from the scene tree (hardcoding paths)
	outside_group = get_tree().get_nodes_in_group("ice")[0]
	cave_group = get_tree().get_nodes_in_group("ice")[1]
	cave_group.visible = true;
	outside_group.visible = false;
	

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Sigmiukas" and cave_group.visible == true :
		BackgroundFade.transition()
		await BackgroundFade.on_trasition_finished
		outside_group.visible = true
		cave_group.visible = false
	elif body.name == "Sigmiukas" and outside_group.visible == true :
		BackgroundFade.transition()
		await BackgroundFade.on_trasition_finished
		outside_group.visible = false
		cave_group.visible = true
		
