extends Area2D
# Hardcoding the scene tree path for the background groups
var outside_group : ParallaxBackground
var cave_group : ParallaxBackground

func _ready():
	# Get the nodes directly from the scene tree (hardcoding paths)
	#outside_group = $"../ParallaxBackground/outside_group" # Adjust the path to your scene
	#cave_group = $"../ParallaxBackground/cave_group" # Adjust the path
	
	#var residence = get_node("../residence_background") # adjust this path based on where your area node is!
	var parallax_bg = get_node("../ParallaxBackground")
	cave_group = parallax_bg.get_node("cave_group")
	outside_group = parallax_bg.get_node("outside_group")
	print("veikia")
	
	
	outside_group.visible = true
	cave_group.visible = false

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Sigmiukas" and outside_group.visible == true :
		print("entered")
		cave_group.visible = true
		outside_group.visible = false
	elif body.name == "Sigmiukas" and cave_group.visible == true :
		print("entered")
		cave_group.visible = false
		outside_group.visible = true
