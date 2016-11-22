
extends KinematicBody2D

onready var health = 70


func _on_StartTimer_timeout():
	get_node("AnimationPlayer").play_backwards("submerge")
	get_parent().get_node("SamplePlayer2D").play("emerge")
	get_node("StartTimer").stop()

func take_damage(amount):
	if get_parent().has_method("take_damage"):
		get_parent().take_damage(amount)
	get_node("HitAnimation").play("hit")
	get_parent().get_node("SamplePlayer2D").play("hit")
	health = health - amount
	if health <= 0:
		submerge()

func _on_EmergeTimer_timeout():
	health = 70
	get_node("EmergeTimer").stop()
	get_node("AnimationPlayer").play_backwards("submerge")
	get_parent().get_node("SamplePlayer2D").play("emerge")

func submerge():
	get_parent().get_node("SamplePlayer2D").play("submerge")
	get_node("EmergeTimer").set_wait_time(10)
	get_node("EmergeTimer").start()
	get_node("AnimationPlayer").play("submerge")



