
extends StaticBody2D

func take_damage(amount):
	get_parent().take_damage(amount)
	get_parent().get_parent().get_node("SamplePlayer2D").play("hit")