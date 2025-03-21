extends ProgressBar

var parent
var max_health
var min_health

# Called when the node enters the scene tree for the first time.
func _ready():
	parent=get_parent()
	max_health=parent.max_health
	min_health=parent.min_health
	max_value=parent.max_health
	min_value=parent.min_health
 # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.value= parent.health
	if parent.health != max_health:
		self.visible = true
		if parent.health == min_health:
			self.visible = true
	else:
		self.visible=true
