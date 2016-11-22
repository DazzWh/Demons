
extends Control

onready var paused = false

func _ready():
	set_process_input(true)

func _input(event):
	if(event.type == InputEvent.KEY and event.scancode == KEY_ESCAPE and !event.is_echo() and !event.is_pressed()):
		if paused:
			get_tree().set_pause(false)
			get_parent().get_parent().load_home()

		if !paused:
			Input.action_release("ui_cancel")
			show()
			get_tree().set_pause(true)
			paused = true

	elif event.type == InputEvent.KEY and !event.is_echo() and !event.is_pressed():
		paused = false
		get_tree().set_pause(false)
		hide()