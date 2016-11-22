extends Node2D

onready var health = 500

func take_damage(amount):
	health = health - amount
	get_parent().get_node("UI/BossHealthBar").set_value(health)
	if(health <= 0):
		die()

func die():
	global.killed_kracken = true
	get_node("SamplePlayer2D").play("end")
	get_node("Head").get_node("AnimationPlayer").play("submerge")
	get_node("Head").get_node("EmergeTimer").stop()

	var tentacles = get_node("Tentacles").get_children()
	for t in tentacles:
		t.die()
	get_node("BigTentacle").die_end()
	get_node("BigTentacle2").die_end()
	get_node("BigTentacle3").die_end()

	get_parent().get_node("AnimationPlayer").play("Victory")