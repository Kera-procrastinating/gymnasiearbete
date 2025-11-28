
extends CharacterBody2D #uses velocity to use collision
class_name Astro


@onready var anim: AnimatedSprite2D = $IdleAnimatedSprite2D
@export var speed := 55 
enum{IDLE, WALK}

var state = IDLE
var direction = Input.get_vector("left", "right", "up", "down")

func _physics_process(delta: float) -> void:
	match state:
		IDLE:
			_idle_state(delta)
		WALK:
			_walk_state(delta)

func _idle_state(delta: float)-> void:
	if Input.is_action_just_pressed("up"):
		anim.play("walk_up")
	if Input.is_action_just_pressed("down"):
		anim.play("walk_down")
	if Input.is_action_just_pressed("right"):
		anim.play("walk_right")
	if Input.is_action_just_pressed("left"):
		$IdleAnimatedSprite2D.flip_h = false
		anim.play("walk_right")

func _walk_state(delta: float)-> void:
	pass





"""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = Vector2(368,288)
	anim.play("idle_down")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction = Input.get_vector("left", "right", "up", "down")	#project, project settings,inmatnings karta, add name and assign key 
	velocity = direction * speed #delta inbuilt
	if direction.x < 0:
		$IdleAnimatedSprite2D.flip_h = true
		if velocity.x > 0: 
			anim.play("walk_right")
		else:
			anim.play("idle_right")	
	elif direction.x > 0:
		$IdleAnimatedSprite2D.flip_h = false
		if velocity.x < 0: 
			anim.play("walk_right")
		else:
			anim.play("idle_right")
	elif direction.y < 0:
		if velocity.x > 0: 
			anim.play("walk_up")
		else:
			anim.play("idle_up")
	elif direction.y > 0:
		if velocity.x > 0: 
			anim.play("walk_down")
		else:
			anim.play("idle_down")

	move_and_slide()# applies velocity to character

"""
