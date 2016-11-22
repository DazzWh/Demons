
extends Sprite

# member variables here, example:
# var a=2
# var b="textvar"
onready var light = preload("res://Images/pentagram_light_green.tex")
onready var pent =  preload("res://Images/pentagram_green.tex")

func _ready():
	if global.killed_kracken:
		get_node("Light2D").set_color("#00FF00")
		get_node("Light2D").set_texture(light)
		set_texture(pent)


