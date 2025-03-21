extends ProgressBar

var parent
var max_mana
var min_mana

# Called when the node enters the scene tree for the first time.
func _ready():
	parent=get_parent()
	max_mana=parent.max_mana
	min_mana=parent.min_mana
 # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.value= parent.mana
	if parent.mana != max_mana:
		self.visible = true
		if parent.mana == min_mana:
			self.visible = true
	else:
		self.visible=true
