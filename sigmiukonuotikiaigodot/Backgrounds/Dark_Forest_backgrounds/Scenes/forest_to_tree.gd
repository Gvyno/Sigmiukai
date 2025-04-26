extends Area2D
# Hardcoding the scene tree path for the background groups
var forest_group : ParallaxBackground
var tree_group : ParallaxBackground
var clouds_group : ParallaxBackground
@export var collision_size : Vector2 = Vector2(100, 50) # Default size
@onready var collision_shape = $CollisionShape2D

func _ready():
	
	# Get the nodes directly from the scene tree (hardcoding paths)
	forest_group = get_tree().get_nodes_in_group("df")[0]
	tree_group = get_tree().get_nodes_in_group("df")[1]
	clouds_group = get_tree().get_nodes_in_group("df")[2]
	forest_group.visible = true
	print(forest_group.visible)
	tree_group.visible = false
	clouds_group.visible = false
	

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Sigmiukas" and forest_group.visible == true :
		BackgroundFade.transition()
		await BackgroundFade.on_trasition_finished
		tree_group.visible = true
		forest_group.visible = false
	elif body.name == "Sigmiukas" and tree_group.visible == true :
		BackgroundFade.transition()
		await BackgroundFade.on_trasition_finished
		tree_group.visible = false
		forest_group.visible = true
		
