extends Area2D
# Hardcoding the scene tree path for the background groups
var outside_group : ParallaxBackground
var cave_group : ParallaxBackground
@export var collision_size : Vector2 = Vector2(100, 50) # Default size
@onready var collision_shape = $CollisionShape2D

func _ready():
	# Get the nodes directly from the scene tree (hardcoding paths)
	outside_group = $"../Parallax2D/outside_group" # Adjust the path to your scene
	cave_group = $"../Parallax2D/cave_group" # Adjust the path
	outside_group.visible = true
	cave_group.visible = false
	if collision_shape.shape is RectangleShape2D:
		collision_shape.shape.extents = collision_size / 2

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Sigmiukas" and outside_group.visible == true :
		cave_group.visible = true
		#transition_screen.transition()
		#await transition_screen.on_transition_finished
		outside_group.visible = false
	elif body.name == "Sigmiukas" and cave_group.visible == true :
		print("entered")
		cave_group.visible = false
		outside_group.visible = true
		

	
