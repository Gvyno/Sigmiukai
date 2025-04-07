class_name HurtBox
extends Area2D

signal ItakeDamage(damage: int)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#connect("area_entered", _on_area_entered)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _init() -> void:
#	collision_layer=0
#	collision_mask=4
	pass
	
'''
func _on_area_entered(hitbox: Hitbox)-> void:
	print("Something entered the enemy hitbox:", hitbox)
	print(hitbox.name)
	print(hitbox.get_path())
	emit_signal("ItakeDamage",1)
	pass
'''
