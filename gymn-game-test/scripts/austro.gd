extends CharacterBody2D #uses velocity to use collision
class_name Astro

@onready var anim: AnimatedSprite2D = $IdleAnimatedSprite2D
@export var speed := 55 
enum{IDLE, WALK}

const DIGGING_RANGE= 18

var state = IDLE
var direction = Input.get_vector("left", "right", "up", "down")
var last_moving_dir = Vector2.ZERO
var is_digging : bool

func _ready() -> void:
	position = Vector2(343,288)
	anim.play("idle_down")

func _physics_process( delta: float) -> void:
	
	Globals.player_global_position = global_position
	
	var dir = Input.get_vector("left", "right", "up", "down")
	velocity = dir * speed
	
	if dir != Vector2.ZERO: #vector.zero faces nowhere when button isnt being pressed
		last_moving_dir = dir # essentially, if the inputed direction is not nothing, 
		_walk_state(dir)	#then face the inputed direction and walk...i dont get it..
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
