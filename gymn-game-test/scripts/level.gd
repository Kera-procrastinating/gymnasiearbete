extends Node2D

@export var austro : Astro
@export var tilemaplayer : TileMapLayer

@onready var pauseui = $CanvasLayer/PauseUI #pause scene in level scene
@onready var rubbishsorting = $CanvasLayer/RubbishSort #rubbish short scene in level scene
@onready var Items = $Items
@onready var alive_ground = $LargeFlatArea/AiveLand
@onready var soil_tile = $LargeFlatArea/SoilTile
@onready var Trees = $Trees
@onready var rubbish_pile_tile = get_node("Environment/Rubbish/RubbishPileTile")
@onready var you_win_scene = $CanvasLayer/YouWin
@onready var water_splash = $MusicAndEffects/WaterSplashSound
@onready var bg_music = $CanvasLayer/MusicUI/BgMusic
@onready var won_music = $MusicAndEffects/WonMusic


var tree_scene = preload("res://scenes/tree.tscn")


func _ready() -> void:
	Globals.level_instance = self
	
	var instantiated_level = Globals.level_scene.instantiate()
	Globals.level_instance = instantiated_level
	
	var inst = Globals.rubbish_sort_scene.instantiate()
	Globals.rubbishsort_instance = inst #takes instatiates scene back to globals

func _process(delta: float) -> void:
	if Input.is_action_pressed("pause"): #p button
		pauseui.visible = !pauseui.visible
		get_tree().paused = true #pauses absolutely everything, the whole game
	
	if Input.is_action_just_pressed("sorting"): #l button
		rubbishsorting.visible = !rubbishsorting.visible 
		Globals.rubbish_sort_visible = !Globals.rubbish_sort_visible #variable to be able to drop items, in the global code
	
	#to win the game
	if Globals.trees_fully_grown == 3 and Globals.no_tiles and not Globals.has_won:
		Globals.has_won = true
		you_win_scene.visible = true
		bg_music.stop()
		won_music.play()
		
	update_ground()
	#Globals.objectives_completed > 2 and 
	if Globals.seeds_used:
		if Input.is_action_just_pressed("right_click"):
			var char_pos: Vector2 = Globals.player_global_position
			var tile_map_pos: Vector2i = soil_tile.local_to_map(char_pos)
			
			soil_tile.set_cell(tile_map_pos, 0 ,Vector2(12,24))

			Globals.seeds_used = false
	
	if Globals.grow_tree:
		if Input.is_action_just_pressed("right_click"):
			water_splash.play()
			var char_pos = Globals.player_global_position
			var tree_area = get_area_at_position(char_pos)
		
			if tree_area: #is my player interacting with an area2D, works for any type of tree
				if tree_area and tree_area.get_parent().has_method("grow"): #if that area is a tree
					var tree = tree_area.get_parent() #get the areas parent (node)
					tree.grow() #update tree sprite
			else: #if there is not already a tree there
				var tile_pos: Vector2i = soil_tile.local_to_map(soil_tile.to_local(char_pos)) #if player is on soil tile
				var tile_data = soil_tile.get_cell_tile_data(tile_pos)#get the data of that tile
			
				if tile_data != null: #if there is soil there
					var tree = spawn_tree_at_tile(tile_pos) #grow sapling(smallest tree)
					soil_tile.erase_cell(tile_pos) #remove soil tile
				
				Globals.grow_tree = false
	
	if Globals.tree_cut:
		if Input.is_action_just_pressed("right_click"):
			var char_pos = Globals.player_global_position
			var tree_area = get_area_at_position(char_pos)
			
			if tree_area: #is my player interacting with an area2D, works for any type of tree
				if tree_area and tree_area.get_parent().has_method("grow"): #if that area is a tree
					var tree = tree_area.get_parent() #get the areas parent (node)
					tree.queue_free()
					rubbish_pile_tile.spawn_objective_tools(6)#spawn plum
					rubbish_pile_tile.spawn_objective_tools(6)
					rubbish_pile_tile.spawn_objective_tools(6)
					rubbish_pile_tile.spawn_objective_tools(7)
					rubbish_pile_tile.spawn_objective_tools(7)
					
				Globals.tree_cut = false

func get_area_at_position(pos: Vector2) -> Area2D:
	
	var space_state = get_world_2d().direct_space_state #get the world

	var query = PhysicsPointQueryParameters2D.new() #make godot check for areas constantly
	query.position = pos #check at the position of the player
	query.collide_with_areas = true #check if character in area
	query.collide_with_bodies = false #dont check i character in bodies
	
	var results = space_state.intersect_point(query) #if there is an area that the player collides in
	
	for hit in results:
		if hit.collider is Area2D:
			return hit.collider #alltså get back a dict of the areas information
	
	return null

func spawn_tree_at_tile(tile_pos: Vector2i):
	var tree = tree_scene.instantiate()
	var world_pos = rubbish_pile_tile.map_to_local(tile_pos)
	tree.global_position = world_pos
	
	add_child(tree)
	
	return tree

func update_ground():
	if Globals.objectives_completed == 0:
		alive_ground.modulate.a = 0
	elif Globals.objectives_completed == 1:
		alive_ground.modulate.a = 0.2
	elif Globals.objectives_completed == 2:
		alive_ground.modulate.a = 0.4
	elif Globals.objectives_completed == 3:
		alive_ground.modulate.a = 0.6
	elif Globals.objectives_completed == 4:
		alive_ground.modulate.a = 0.8
