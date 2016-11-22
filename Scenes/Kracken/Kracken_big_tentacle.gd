
extends KinematicBody2D

var health = 50

var emerged = false

func _ready():
	get_node("EmergeTimer").set_wait_time(rand_range(6, 35))
	get_node("EmergeTimer").start()

func has_emerged():
	get_parent().get_parent().get_node("Player").get_node("Camera2D").shake(0.2, 50, 50)
	get_node("AnimationPlayer").play("Wiggle")
	get_node("SubmergeTimer").set_wait_time(30)
	get_node("SubmergeTimer").start()

func _on_EmergeTimer_timeout():
	health = 50
	emerged = true
	get_node("AnimationPlayer").play("Emerge")
	get_node("EmergeTimer").stop()

func take_damage(amount):
	#if get_parent().has_method("take_damage"):
	#	get_parent().take_damage(amount * 0.2)
	get_node("HitAnimation").play("hit")
	get_parent().get_node("SamplePlayer2D").play("hit")
	health = health - amount
	if health <= 0:
		die()

func die_end():
	if emerged:
		die()
	get_node("EmergeTimer").stop()
	get_node("SubmergeTimer").stop()

func die():
	emerged = false
	get_node("AnimationPlayer").play("Submerge")
	get_node("EmergeTimer").set_wait_time(rand_range(6, 35))
	get_node("EmergeTimer").start()
	get_node("SubmergeTimer").stop()


func _on_DeathArea2d_body_enter( body ):
		if body.get_name() == "Player":
			body.take_damage(10000)

func _on_SubmergeTimer_timeout():
	die()
