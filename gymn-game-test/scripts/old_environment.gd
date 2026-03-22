extends StaticBody2D

@onready var minivan_collision = $Area2D/MinivanCollision
@onready var car_1_collision = $Area2D/Car1Collision

@onready var minivan = $MinivanCollision

@onready var rubbish_pile_tile = get_parent().get_node("Rubbish/RubbishPileTile")
#from rubbish_pile_tile scene in order to take sspawn func

var dig_progress = 0
var player_inside = false
const DIG_TIME = 1

func _process(delta: float):
	if player_inside:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			dig_progress += delta 
			if dig_progress >= DIG_TIME:
				print(dig_progress)########################## not working #################
				rubbish_pile_tile.spawn_random_items(10)
				minivan.queue_free()
			else:
				dig_progress = 0


func _on_area_2d_body_entered(body: Astro) -> void: 
	player_inside = true

func _on_area_2d_body_exited(body: Astro) -> void:
	player_inside = false
