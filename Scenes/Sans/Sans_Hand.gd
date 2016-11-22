extends KinematicBody2D

onready var hitAnim = get_node("HitAnimationPlayer")
onready var start_pos = get_global_pos()
onready var next_pos  = get_global_pos()
var speed = 0.2

var health = 150

func _ready():
	set_fixed_process(false)

func start():
	set_fixed_process(true)

func _fixed_process(delta):
	var distance_to_next_pos = next_pos.distance_to(get_global_pos())
	if(next_pos == null or distance_to_next_pos < 1):
		get_new_move_pos()

	move( (next_pos-get_global_pos()).normalized() * speed )

func get_new_move_pos():
	var x = rand_range(start_pos.x - 20, start_pos.x + 20)
	var y = rand_range(start_pos.y - 20, start_pos.y + 10)
	next_pos = Vector2(x, y)

func take_damage(amount):
	health = health - amount
	if health <= 0:
		die()
	else:
		hitAnim.play("GotHit")
	get_parent()._on_take_damage(amount * 0.5)

func die():
	queue_free()


