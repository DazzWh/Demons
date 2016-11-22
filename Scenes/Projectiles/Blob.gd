extends KinematicBody2D

var damage = 10
var speed  = 150

var direction = Vector2(0, 0)

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	move(direction.normalized() * speed * delta)

func _on_Area2D_body_enter( body ):
	if(body.get_name() == "Player" and body.has_method("take_damage")):
		body.take_damage(damage)
	queue_free()