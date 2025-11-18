extends CharacterBody2D #uses velocity to use collision
class_name Astro


@onready var anim: AnimatedSprite2D = $IdleAnimatedSprite2D

@export var speed := 55 #can also use ":int =" this assigns a variable to a specific typ that cannot later be changed. The one used means that it is assined to the type that was entered here. in this case it would be int because of the 500. d 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = Vector2(368,288)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction = Input.get_vector("left", "right", "up", "down")	#project, project settings,inmatnings karta, add name and assign key 
	velocity = direction * speed #delta inbuilt
	if direction.x < 0: 
		$IdleAnimatedSprite2D.flip_h = true
		anim.play("idle_left")
	elif direction.x > 0:
		$IdleAnimatedSprite2D.flip_h = false
		anim.play("idle_left")
	elif direction.y < 0:
		anim.play("idle_up")
	elif direction.y > 0:
		anim.play("idle_down")

	move_and_slide()# applies velocity to character
