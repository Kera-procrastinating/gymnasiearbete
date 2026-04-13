extends Node2D

@onready var objective_bar_sprite = $ObjectiveBar
@onready var label = $Panel/Objective
@onready var water_collision = $Area2D/WaterCollision
@onready var rubbish_pile_tile_scene = get_parent().get_parent().get_node("Environment/Rubbish/RubbishPileTile")
@onready var obj1 = $Node2D/ObjectiveInfo/Obj1
@onready var obj2 = $Node2D/ObjectiveInfo/Obj2
@onready var obj3 = $Node2D/ObjectiveInfo/Obj3
@onready var obj4 = $Node2D/ObjectiveInfo/Obj4
@onready var obj_info = $Node2D/ObjectiveInfo

var tree_grown_1 = false

func _process(delta: float) -> void:
	if Globals.objective == 1 and not Globals.objective_1_complete: #collect 10 rubbish
		objects_collected()
	elif Globals.objective == 2: #pick up bucket with water
		fill_bucket()
	elif Globals.objective == 3: #grow 5 trees
		grow_5_trees()
	elif Globals.objective == 4: #get rid of all rubbish
		remove_all_rubbish()
	
	update_obj_info()

func update_objective_bar():
	Globals.objectives_completed += 1
	Globals.objectives_completed = clamp(Globals.objectives_completed, 0, Globals.objective_bar_list.size()-1)
	objective_bar_sprite.texture = Globals.objective_bar_list[Globals.objectives_completed]
	$PickupSound.play()
	
func objects_collected(): ####1
	label.text = "Collect 10 rubbish"
	
	if Globals.invno > 10 and not Globals.objective_1_complete:
		Globals.objective_1_complete = true
		
		rubbish_pile_tile_scene.spawn_objective_tools(0) #bucket spawns by the spaceship
		update_objective_bar()

		
		
		label.text = "reward at spaceship"
		await get_tree().create_timer(5.0).timeout
		
		Globals.objective = 2

func _on_area_2d_body_entered(body: Astro):#is astro by water
	Globals.reached_water = true


func fill_bucket(): ####2
	label.text = "click use to fill bucket"

	for item in Globals.inventory:
		if not item == null:
			if item["type"] == "bucket" and item["name"] == "filled" :
				update_objective_bar()
				Globals.objective = 3

func grow_5_trees():###3
	label.text = "grow 3 trees using seeds"
	
	if Globals.trees_fully_grown ==1 and not tree_grown_1:
		rubbish_pile_tile_scene.spawn_objective_tools(5)
		tree_grown_1 = true
	
	if Globals.trees_fully_grown >= 3:
		update_objective_bar()
		
		Globals.objective = 4
		
	
func remove_all_rubbish():###4
	if Globals.no_tiles:
		update_objective_bar()
		Globals.objective = 0

func _on_area_2d_body_exited(body: Astro) -> void:
	Globals.reached_water = false
			
func apply_object_effect():
	pass #when button clicked, fill/ empty water :p helll nahhh



func _on_info_button_pressed() -> void:
	obj_info.visible = !obj_info.visible

func update_obj_info():
	if Globals.objective == 1:
		obj1.visible
	elif Globals.objective == 2:
		obj1.visible = false
		obj2.visible = true
	elif Globals.objective == 3:
		obj2.visible = false
		obj3.visible = true
	elif Globals.objective == 4:
		obj3.visible = false
		obj4.visible = true
