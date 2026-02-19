extends StaticBody2D

@onready var minivan_collision = $Area2D/MinivanCollision
@onready var car_1_collision = $Area2D/Car1Collision

@onready var rubbish_pile_tile = get_parent().get_node("Rubbish/RubbishPileTile")
#from rubbish_pile_tile scene in order to take spawn func

func _on_area_2d_body_entered(body: Astro) -> void:
	rubbish_pile_tile.spawn_random_items(10)
	#taken from rubbish_pile_tile scene, spawns x amount of items at mouses position
