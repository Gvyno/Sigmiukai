extends Node2D

@onready var interact_label: Label = $InteractLabel

var current_interactions := []
var can_interact := true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and can_interact:
		print("Interact key pressed")  # Debugging print
		if current_interactions:
			print("Interacting with:", current_interactions[0])  # Debugging print
			can_interact = false
			interact_label.hide()
			
			await current_interactions[0].interact.call()
			
			can_interact = true

func _process(_delta: float) -> void:
	#print("Current interactions:", current_interactions)  # Debugging print
	if current_interactions and can_interact:
		#print("Sorting interactions")
		current_interactions.sort_custom(_sort_by_nearest)
		if current_interactions[0].is_interactable:
			#print("Label should be visible now!")  # Debugging print
			interact_label.text = current_interactions[0].interact_name
			interact_label.show()
		else:
			#print("Object is not interactable")
			interact_label.hide()
	else:
		#print("No interactions, hiding label")
		interact_label.hide()

func _sort_by_nearest(area1, area2):
	var area1_dist = global_position.distance_to(area1.global_position)  # Fixed distance calculation
	var area2_dist = global_position.distance_to(area2.global_position)
	return area1_dist < area2_dist

func _on_interact_range_area_entered(area: Area2D) -> void:
	print("Entered interact range:", area)  # Debugging print
	current_interactions.push_back(area)
	print("Current interactions:", current_interactions)

func _on_interact_range_area_exited(area: Area2D) -> void:
	print("Exited interact range:", area)  # Debugging print
	current_interactions.erase(area)
	print("Current interactions after exit:", current_interactions)
	
