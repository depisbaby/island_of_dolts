extends LineEdit

@onready var terminal :Terminal = $".."

func _gui_input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_UP:
			terminal.UpArrow()
			accept_event()  # stops LineEdit from processing it
		if event.keycode == KEY_DOWN:
			terminal.DownArrow()
			accept_event()  # stops LineEdit from processing it
