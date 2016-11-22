extends KinematicBody2D

onready var health = 10

var type = false

var emerged = false

var blob = preload("res://Scenes/Projectiles/Blob.tscn")

func _ready():
	get_node("Sprite").set_frame(17)
	#get_node("EmergeTimer").connect("timeout", self, "_on_EmergeTimer_timeout")
	#get_node("AttackTimer").connect("timeout", self, "_on_AttackTimer_timeout")
	get_node("EmergeTimer").set_wait_time(rand_range(6,26))
	get_node("EmergeTimer").start()

func take_damage(amount):
	if get_parent().get_parent().has_method("take_damage"):
		get_parent().get_parent().take_damage(amount * 0.5)
	get_node("HitAnimation").play("hit")

	get_parent().get_parent().get_node("SamplePlayer2D").play("hit")

	health = health - amount
	if health <= 0:
		submerge()

func submerge():
	emerged = false
	get_node("AttackTimer").stop()
	if type:
		get_node("AnimationPlayer").play("Submerge")
	else:
		get_node("AnimationPlayer").play("Submerge2")
	get_node("EmergeTimer").set_wait_time(rand_range(5,20))
	get_node("EmergeTimer").start()

func has_emerged():
	health = 10

	get_node("AttackTimer").set_wait_time(rand_range(2,4))
	get_node("AttackTimer").start()
	if(type):
		get_node("AnimationPlayer").play("Wiggle")
	else:
		get_node("AnimationPlayer").play("Wiggle2")

func _on_EmergeTimer_timeout():
	emerged = true
	type = rand_range(0, 1) > 0.5
	get_node("EmergeTimer").stop()
	if(type):
		get_node("AnimationPlayer").play("Emerge")
	else:
		get_node("AnimationPlayer").play("Emerge2")

func die():
	if emerged:
		submerge()
	get_node("EmergeTimer").stop()


func _on_AttackTimer_timeout():
	get_node("AttackTimer").set_wait_time(rand_range(2,4))
	get_node("AttackTimer").start()

	var new_blob
	new_blob = blob.instance()

	new_blob.get_node("Area2D").set_collision_mask_bit(0, true)
	new_blob.get_node("Area2D").set_collision_mask_bit(1, false) # first bit is bosses
	new_blob.get_node("Area2D").set_collision_mask_bit(4, true)  # fourth bit is big tentacle

	var dir = (get_parent().get_parent().get_parent().get_node("Player").get_pos() - get_global_pos())
	new_blob.direction = dir
	new_blob.set_rot(atan2(dir.x, dir.y))

	new_blob.set_global_pos(get_global_pos())

	get_parent().get_parent().get_parent().get_node("Projectiles").add_child(new_blob)
