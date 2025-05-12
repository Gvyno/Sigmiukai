extends Area2D
var Collision=true
func _on_body_entered(body: Node2D) -> void:
	if body.name == "Sigmiukas" and body.has_method("save_player_data"):
		var current_scene_file = get_tree().current_scene.scene_file_path
		print("Current scene path: ", current_scene_file)

		match current_scene_file:
			"res://Worlds/Sigmiukas Residence.tscn":
				body.getabilitycast()
				body.save_player_data()
				TransitionScene.transition()
				await TransitionScene.on_trasition_finished
				get_tree().change_scene_to_file("res://Worlds/Dark Forest.tscn")
			"res://Worlds/Dark Forest.tscn":
				if(BossesState.forest_boss_dead):
					body.getabilitydoublejump()
					TransitionScene.transition()
					await TransitionScene.on_trasition_finished
					body.save_player_data() 
					get_tree().change_scene_to_file("res://Worlds/Ice Caves.tscn")
				else:
					print("BOSS IS NOT DEAD")
					if(body.name == "Sigmiukas"):
						body.apply_knockback("left",500);
			"res://Worlds/Ice Caves.tscn":
							if(BossesState.ice_caves_boss_dead):
								body.getabilitycast()
								TransitionScene.transition()
								await TransitionScene.on_trasition_finished
								body.save_player_data() 
								get_tree().change_scene_to_file("res://Worlds/Dragon's Lair.tscn")
							else:
								if(body.name == "Sigmiukas"):
									body.apply_knockback("left",500);
			_:
				print("No matching scene found or already at the last level.")
	else:
		print("world change u no player wthhhhhh")


func _on_timer_timeout() -> void:
	if Collision:
		$CollisionShape2D.disabled=true
		Collision=false
	else:
		$CollisionShape2D.disabled=false
		Collision=true
	pass # Replace with function body.
