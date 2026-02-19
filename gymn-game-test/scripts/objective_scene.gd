extends Node2D

@onready var objective_bar_sprite = $ObjectiveBar
@onready var label = $Panel/Objective
@onready var water_collision = $Area2D/WaterCollision
@onready var rubbish_pile_tile_scene = get_parent().get_parent().get_node("Environment/Rubbish/RubbishPileTile")

var objectives_completed = 0
var objective = 1
var reached_water = false
var objective_1_complete = false #_process will make bucket spawn in 60 fps making hundreds of buckets
#globals invo(objects collected) stays true and buckets spawn in . but creating a variable and then changing it, it only runs once

var objective_bar_list = [
	preload("res://assets/bits and bobs/objective tools/Bar images/empty_bar.png"),
	preload("res://assets/bits and bobs/objective tools/Bar images/1:4 bar.png"),
	preload("res://assets/bits and bobs/objective tools/Bar images/1:2 bar.png"),
	preload("res://assets/bits and bobs/objective tools/Bar images/3:4 bar.png"),
	preload("res://assets/bits and bobs/objective tools/Bar images/full_bar.png")
]

func _process(delta: float) -> void:
	if objective == 1 and not objective_1_complete:
		objects_collected()
	elif objective == 2:
		if reached_water == false:
			label.text = "Get to a body of water"
	elif objective == 3:
		label.text = ""
		await get_tree().create_timer(2.0).timeout 

func update_objective_bar():
	objectives_completed += 1
	objectives_completed = clamp(objectives_completed, 0, objective_bar_list.size() - 1)
	objective_bar_sprite.texture = objective_bar_list[objectives_completed]
	
func objects_collected(): ####1
	label.text = "Collect 10 rubbish"
	
	if Globals.invno > 10 and not objective_1_complete:
		objective_1_complete = true
		
		rubbish_pile_tile_scene.spawn_objective_tools(0) #bucket spawns by the spaceship
		update_objective_bar()
		
		label.text = "Objective complete"
		await get_tree().create_timer(2.0).timeout # strop reading code for four seconds before continuing
		
		label.text = "reward at spaceship"
		await get_tree().create_timer(6.0).timeout
		
		objective = 2

func _on_area_2d_body_entered(body: Astro):####2
	reached_water = true
	if reached_water == true:
		if objective == 2:
			await get_tree().create_timer(0.25).timeout #little delay after reaching water before label changes
			label.text = "Objective complete"
			update_objective_bar()
			await get_tree().create_timer(5.0).timeout # strop reading code for five seconds before continuing
			objective = 3
			
func apply_object_effect():
	pass
