extends MarginContainer

@onready var label = $MarginContainer/Label
@onready var timer = $LetterDisplayTimer

const MAX_WIDTH = 256

var text = ""
var letter_index = 0
var letter_time = 0.03
var space_time = 0.06
var punctuation_time = 0.2

signal finished_displaying()

var initial_position = Vector2()  # To store the initial position

func display_text(text_to_display):
	text = text_to_display
	label.text = ""  # Clear label

	letter_index = 0  # Reset index
	_display_letter()  # Manually trigger letter display

	# Store initial position before resizing
	initial_position = global_position

	# Wait until resize is complete
	await resized

	# Set maximum width and apply autowrap if necessary
	custom_minimum_size.x = min(size.x, MAX_WIDTH)
	if size.x > MAX_WIDTH:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await resized
		await resized
		custom_minimum_size.y = size.y

	# Reposition the container to center it
	global_position = initial_position  # Restore initial position

	# Continue displaying letters from where we left off after resizing
	_display_letter()

func _display_letter():
	if letter_index >= text.length():
		finished_displaying.emit()
		return

	label.text += text[letter_index]

	letter_index += 1

	var wait_time = letter_time  # Default to normal letter speed

	match text[letter_index - 1]:  # Check the last added letter
		"!", ".", ",", "?":
			wait_time = punctuation_time
		" ":
			wait_time = space_time

	timer.start(wait_time)  # FORCE start the timer

func _on_letter_display_timer_timeout():
	_display_letter()
