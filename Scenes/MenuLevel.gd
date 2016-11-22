
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	set_process_input(true)
	if global.killed_kracken and global.killed_sans:
		get_node("CompleteAnim").play("win")

func _input(event):
	if(event.type == InputEvent.KEY and event.scancode == KEY_ESCAPE and !event.is_echo() and !event.is_pressed()):
		get_tree().quit()

func _on_SansPortal_body_enter( body ):
	if body.get_name() == "Player" and !get_node("SwitchLevelAnimator").is_playing():
		get_node("SwitchLevelAnimator").play("sans")

func sans():
	get_tree().change_scene("res://Scenes/SansLevel.tscn")


func _on_KrackenPortal_body_enter( body ):
	if body.get_name() == "Player" and !get_node("SwitchLevelAnimator").is_playing():
		get_node("SwitchLevelAnimator").play("kracken")

func kracken():
	get_tree().change_scene("res://Scenes/KrackenLevel.tscn")


func _on_CreditsPortal_body_enter( body ):
	if body.get_name() == "Player":
		get_node("CreditsPortal/AnimationPlayer").play("Show credits")


func _on_CreditsPortal_body_exit( body ):
	if body.get_name() == "Player":
		get_node("CreditsPortal/AnimationPlayer").play("Hide credits")
