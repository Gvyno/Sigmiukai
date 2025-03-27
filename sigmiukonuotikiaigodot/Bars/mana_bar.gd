extends ProgressBar
@onready var sigmiukas: CharacterBody2D = $Sigmiukas

var parent
var max_mana
var min_mana

# Called when the node enters the scene tree for the first time.
func _ready():
	if sigmiukas:
		max_mana=sigmiukas.max_mana
		min_mana=sigmiukas.min_mana
		max_value=sigmiukas.max_mana
		min_value=sigmiukas.min_mana
 # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if sigmiukas:
		self.value= sigmiukas.mana
		if sigmiukas.mana != max_mana:
			self.visible = true
			if sigmiukas.mana == min_mana:
				self.visible = true
		else:
			self.visible=true
		


func _on_character_body_2d_2_mana_changed(new_mana,new_min_mana,new_max_mana: Variant) -> void:
	self.value=new_mana
	self.max_mana=new_max_mana
	self.min_mana=new_min_mana
	self.min_value=new_min_mana
	self.max_value=new_max_mana
	pass # Replace with function body.
