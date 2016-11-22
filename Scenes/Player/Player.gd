
extends KinematicBody2D

# Gameplay
var speed  = 100
var health = 100
var attack_timeout = 0.5

var dead = false

# Controls
var move_left     = false
var move_right    = false
var move_up       = false
var move_down     = false
var fire_up       = false
var fire_down     = false
var fire_left     = false
var fire_right    = false

var can_attack = false

# Attacks
var dagger = preload("res://Scenes/Projectiles/Dagger.tscn")

# Anim
var facing = "Front"

onready var anim    = get_node("AnimationPlayer")
onready var atk_tmr = get_node("AttackTimer")

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	_get_input()
	_handle_movement(delta)
	_handle_attack()
	_handle_animation()

func _get_input():
	move_left     = Input.is_action_pressed("move_left")
	move_right    = Input.is_action_pressed("move_right")
	move_up       = Input.is_action_pressed("move_up")
	move_down     = Input.is_action_pressed("move_down")
	fire_up       = Input.is_action_pressed("fire_up")
	fire_down     = Input.is_action_pressed("fire_down")
	fire_left     = Input.is_action_pressed("fire_left")
	fire_right    = Input.is_action_pressed("fire_right")

func _handle_movement(delta):
	var velocity = Vector2(0, 0)
	if (move_left):
		velocity.x = -1
	elif (move_right):
		velocity.x = 1
	if (move_up):
		velocity.y = -1
	elif (move_down):
		velocity.y = 1

	move(velocity.normalized() * speed * delta)

	# If colliding on a wall don't lose speed
	if (is_colliding()):
		var n = get_collision_normal()
		var motion = velocity.normalized() * speed * delta
		motion = n.slide(motion)
		velocity = n.slide(velocity)
		move(motion)

func _handle_attack():
	if !can_attack or !isAttackButtonDown():
		return

	var new_dagger
	new_dagger = dagger.instance()
	new_dagger.get_node("Area2D").set_collision_mask_bit(0, false)
	new_dagger.get_node("Area2D").set_collision_mask_bit(1, true) # first bit is bosses

	var dir = Vector2(0,0)

	if fire_up:
		dir = dir + Vector2(0, -1)
	if fire_down:
		dir = dir + Vector2(0, 1)
	if fire_left:
		dir = dir + Vector2(-1, 0)
	if fire_right:
		dir = dir + Vector2(1, 0)

	new_dagger.direction = dir
	new_dagger.set_rot(atan2(dir.x, dir.y))
	get_parent().get_node("Projectiles").add_child(new_dagger)
	new_dagger.set_pos(get_pos() + (dir * 10))
	# Set timer
	can_attack = false
	atk_tmr.set_wait_time(attack_timeout)
	atk_tmr.start()

func isAttackButtonDown():
	return (fire_up or fire_down or fire_right or fire_left) and !(fire_up and fire_down) and !(fire_left and fire_right)

func _handle_animation():

	var travel = get_travel()

	if isAttackButtonDown():
		if fire_up:
			get_node("Sprite").set_flip_h(false)
		if fire_left:
			get_node("Sprite").set_flip_h(true)
		if fire_right:
			get_node("Sprite").set_flip_h(false)
		if fire_down:
			facing = "Front"

		if travel == Vector2(0,0):
			if !isOnWalkingAnimation():
				anim.play("Front_Idle")
			return

		if !isOnWalkingAnimation():
			anim.play(facing + "_Walk")

	if !isAttackButtonDown():
		if travel.x < 0:
			get_node("Sprite").set_flip_h(true)
			if !isOnWalkingAnimation():
				anim.play(facing + "_Walk")

		if travel.x > 0:
			get_node("Sprite").set_flip_h(false)
			if !isOnWalkingAnimation():
				anim.play(facing + "_Walk")

		if travel.y > 0 and anim.get_current_animation() != "Front_Walk":
			facing = "Front"
			if !isOnWalkingAnimation():
				anim.play(facing + "_Walk")
				return

		if travel.y < 0 and anim.get_current_animation() != "Back_Walk":
			if !isOnWalkingAnimation():
				anim.play(facing + "_Walk")
				return

		if travel == Vector2(0, 0) and anim.get_current_animation() != "Front_Idle" and anim.get_current_animation() != "Back_Idle":
			facing = "Front"
			anim.play(facing + "_Idle")
			return

func isOnWalkingAnimation():
	return anim.get_current_animation() == "Front_Walk" or anim.get_current_animation() == "Back_Walk"

func _on_AttackTimer_timeout():
	can_attack = true

func take_damage(amount):
	if(dead):
		return

	get_node("SamplePlayer2D").play("hurt")

	health = health - amount
	if get_parent().has_node("UI/HealthBar"):
		get_parent().get_node("UI/HealthBar").set_value(health)

	if(health <= 0):
		die()
	else:
		get_parent().get_node("AnimationPlayer").play("PlayerHit")

func die():
	get_parent().get_node("AnimationPlayer").play("PlayerDeath")
	get_node("AnimationPlayer").play("Player_Death")
	set_fixed_process(false)
	dead = true