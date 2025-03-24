extends RigidBody2D
@onready var interactable: Area2D = $Interactable
@onready var sprite_2d: Sprite2D = $CollisionShape2D/Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interactable.interact = _on_interact # Replace with function body.
	
func _on_interact():
	queue_free()
	print("Player interacted with the object")
   
