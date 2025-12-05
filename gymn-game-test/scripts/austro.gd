extends CharacterBody2D #uses velocity to use collision
class_name Astro

@onready var anim: AnimatedSprite2D = $IdleAnimatedSprite2D
@export var speed := 55 
enum{IDLE, WALK}

var state = IDLE
var direction = Input.get_vector("left", "right", "up", "down")
var last_moving_dir = Vector2.ZERO

func _ready() -> void:
	position = Vector2(343,291)
	anim.play("idle_down")

func _physics_process(delta: float) -> void:
	
	var dir = Input.get_vector("left", "right", "up", "down")
	velocity = dir * speed
	if dir != Vector2.ZERO: #vector.zero faces nowhere when button isn being pressed
		last_moving_dir = dir
		_walk_state(dir)
	else:
		_idle_state()
		
	move_and_slide()
	
func _idle_state()-> void:
	if last_moving_dir.x < 0:
		$IdleAnimatedSprite2D.flip_h = true
		anim.play("idle_right")
	elif last_moving_dir.x > 0:
		$IdleAnimatedSprite2D.flip_h = false
		anim.play("idle_right")
	elif last_moving_dir.y < 0:
		anim.play("idle_up")
	elif last_moving_dir.y > 0:
		anim.play("idle_down")

func _walk_state(direction: Vector2)-> void:
	if direction.x < 0:
		$IdleAnimatedSprite2D.flip_h = true
		anim.play("walk_right")
	elif direction.x > 0:
		$IdleAnimatedSprite2D.flip_h = false
		anim.play("walk_right")
	elif direction.y < 0:
		anim.play("walk_up")
	elif direction.y > 0:
		anim.play("walk_down")
