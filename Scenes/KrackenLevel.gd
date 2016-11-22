extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	get_node("Player").attack_timeout = 0.35
	pass

func change_scene():
	get_tree().change_scene("res://Scenes/KrackenLevel.tscn")


func _on_HomePortal_body_enter( body ):
	if body.get_name() == "Player":
		get_node("AnimationPlayer").play("home")

func load_home():
	get_tree().change_scene("res://Scenes/MenuLevel.tscn")
