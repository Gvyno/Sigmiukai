extends CanvasLayer


@onready var health_bar: ProgressBar = %HealthBar
@onready var mana_bar: ProgressBar = %ManaBar

var hp =100
var mana =100
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_HealthBar(13)
	_update_ManaBar(24) # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
	
func _update_HealthBar(Damage):
	hp=hp-Damage
	health_bar.value=hp
	print(health_bar.value)
	pass
	
func _update_ManaBar(Magic):
	mana=mana-Magic
	mana_bar.value=mana
	pass
