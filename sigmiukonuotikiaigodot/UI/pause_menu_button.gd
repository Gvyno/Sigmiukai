extends TextureButton

func _on_pressed() -> void:
	get_parent().get_node("PausePanel").show()
