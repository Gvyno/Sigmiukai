extends ProgressBar
@onready var sigmiukas: CharacterBody2D = $Sigmiukas

var parent 
var max_health
var min_health

# Called when the node enters the scene tree for the first time.
func _ready():
#	sigmiukas=get_parent()
	if sigmiukas:
		max_health=sigmiukas.max_health
		min_health=sigmiukas.min_health
		max_value=sigmiukas.max_health
		min_value=sigmiukas.min_health
 # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if sigmiukas:
		self.value= sigmiukas.health
		if sigmiukas.health != max_health:
			self.visible = true
			if sigmiukas.health == min_health:
				self.visible = true
		else:
			self.visible=true


func _on_character_body_2d_2_health_changed(new_health,new_min_health,new_max_health: Variant) -> void:
	self.value=new_health
	self.max_health=new_max_health
	self.min_health=new_min_health
	self.min_value=new_min_health
	self.max_value=new_max_health
	pass # Replace with function body.
