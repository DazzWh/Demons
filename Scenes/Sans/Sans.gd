extends KinematicBody2D

var skull = preload("res://Scenes/Projectiles/Skull.tscn")

onready var atk_tmr     = get_node("AttackTimer")
onready var big_atk_tmr = get_node("BigAttackTimer")
onready var big_skull_ammo = 10
onready var big_attacking = false
onready var health = 500

var rightHand = false

func start():
	get_node("Head").start()
	get_node("Hand_Left").start()
	get_node("Hand_Right").start()
	atk_tmr.start()
	big_atk_tmr.start()

func _on_take_damage(amount):
	get_node("SamplePlayer2D").play("Hurt")
	health = health - amount
	get_parent().get_node("UI/BossHealthBar").set_value(health)
	if(health <= 0):
		die()

func die():
	get_node("Head/DeathAnimation").play("Death")
	get_node("Head/CollisionShape2D").queue_free()
	if has_node("Hand_Right/CollisionShape2D"):
		get_node("Hand_Right/CollisionShape2D").queue_free()
	if has_node("Hand_Left/CollisionShape2D"):
		get_node("Hand_Left/CollisionShape2D").queue_free()
	atk_tmr.stop()
	big_atk_tmr.stop()

func _on_AttackTimer_timeout():

	if rightHand and !has_node("Hand_Right"):
		rightHand = !rightHand
		return

	if !rightHand and !has_node("Hand_Left"):
		rightHand = !rightHand
		return

	var new_dagger
	new_dagger = skull.instance()

	new_dagger.get_node("Area2D").set_collision_mask_bit(0, true)
	new_dagger.get_node("Area2D").set_collision_mask_bit(1, false) # first bit is bosses

	new_dagger.direction = Vector2(rand_range(-0.7,0.7), 1)
	new_dagger.set_rot(atan2(0, 1))

	if rightHand and has_node("Hand_Right"):
		new_dagger.set_global_pos(get_node("Hand_Right").get_global_pos() + Vector2(0,10))

	if !rightHand and has_node("Hand_Left"):
		new_dagger.set_global_pos(get_node("Hand_Left").get_global_pos() + Vector2(0,10))

	get_parent().get_node("Projectiles").add_child(new_dagger)

	# Set timer
	rightHand = !rightHand
	atk_tmr.set_wait_time(rand_range(0.1, 0.5))
	atk_tmr.start()


func _on_BigAttackTimer_timeout():

	if !big_attacking:
		big_attacking = true
		get_node("Head/Head_Image").set_frame(6)
		get_node("SamplePlayer2D").play("Angry")
		big_atk_tmr.set_wait_time(3)
		big_atk_tmr.start()
		return

	if big_skull_ammo > 0:
		if big_skull_ammo % 10 == 0:
			get_node("SamplePlayer2D").play("Fire")
		var new_skull = skull.instance()
		new_skull.set_scale(Vector2(1.25,1.25))
		new_skull.get_node("Area2D").set_collision_mask_bit(0, true)
		new_skull.get_node("Area2D").set_collision_mask_bit(1, false) # first bit is bosses

		var dir = (get_parent().get_node("Player").get_pos() - get_node("Head").get_global_pos())

		new_skull.direction = dir
		new_skull.set_rot(atan2(dir.x, dir.y))

		get_parent().get_node("Projectiles").add_child(new_skull)

		new_skull.set_global_pos(get_node("Head").get_global_pos() + Vector2(0,10))

		big_atk_tmr.set_wait_time(0.3)
		big_atk_tmr.start()
		big_skull_ammo = big_skull_ammo - 1
		return

	if big_skull_ammo == 0:

		if !has_node("Hand_Right") and !has_node("Hand_Left"):
			big_skull_ammo = 100
			return


		big_skull_ammo = 10
		big_attacking = false
		get_node("Head/Head_Image").set_frame(1)
		big_atk_tmr.set_wait_time(2)
		big_atk_tmr.start()
		return

func victory():
	global.killed_sans = true
	get_parent().get_node("AnimationPlayer").play("Victory")
