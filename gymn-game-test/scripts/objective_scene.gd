extends Node2D

@onready var objective_bar_sprite = $ObjectiveBar
@onready var label = $Panel/Objective
@onready var water_collision = $Area2D/WaterCollision
@onready var rubbish_pile_tile_scene = get_parent().get_parent().get_node("Environment/Rubbish/RubbishPileTile")

var objective = 1
var objective_1_complete = false #_process will make bucket spawn in 60 fps making hundreds of buckets
#globals invo(objects collected) stays true and buckets spawn in . but creating a variable and then changing it, it only runs once


func _process(delta: float) -> void:
	if objective == 1 and not objective_1_complete:
		objects_collected()
	elif objective == 2:
		if Globals.reached_water == false:
			label.text = "Get to a body of water"
	elif objective == 3:
		fill_bucket()
	elif objective == 4:
		label.text = "click 'l' to sort 10 plastic"
		plastic_sorted()
		

func update_objective_bar():
	Globals.objectives_completed += 1
	Globals.objectives_completed = clamp(Globals.objectives_completed, 0, Globals.objective_bar_list.size() - 1)
	objective_bar_sprite.texture = Globals.objective_bar_list[Globals.objectives_completed]
	$PickupSound.play()
	
func objects_collected(): ####1
	label.text = "Collect 10 rubbish"
	
	if Globals.invno > 10 and not objective_1_complete:
		objective_1_complete = true
		
		rubbish_pile_tile_scene.spawn_objective_tools(0) #bucket spawns by the spaceship
		update_objective_bar()
		
		label.text = "reward at spaceship"
		await get_tree().create_timer(5.0).timeout
		
		objective = 2

func _on_area_2d_body_entered(body: Astro):####2
	Globals.reached_water = true
	if Globals.reached_water == true:
		if objective == 2:
			update_objective_bar()
			objective = 3

func fill_bucket(): ####3
	label.text = "click use to fill bucket"

	for item in Globals.inventory:
		if not item == null:
			if item["type"] == "bucket" and item["name"] == "filled" :
				update_objective_bar()
				objective = 4

func plastic_sorted():
	pass

func _on_area_2d_body_exited(body: Astro) -> void:
	Globals.reached_water = false
			
func apply_object_effect():
	pass #when button clicked, fill/ empty water :p helll nahhh
