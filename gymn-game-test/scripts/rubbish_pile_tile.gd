extends TileMapLayer
class_name rubbish_scene

const DIGGING_RANGE := 15 #a range around the character can only be mined there
const DIG_TIME := 0.75 #takes 0.75 seconds to mine

var dig_progress := 0.0 #counts up w delta

#@onready var items = $Items
@onready var items_node = get_parent().get_parent().get_parent().get_node("Items")
@onready var sort_items_node = get_parent().get_parent().get_parent().get_node("CanvasLayer/RubbishSort/Items_sort")
@onready var rubbishtile = $"."

func _physics_process(delta: float) -> void:
	if (Globals.player_global_position.distance_to(get_global_mouse_position())< DIGGING_RANGE): 
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			dig_progress += delta #starts counting up
			if dig_progress >= DIG_TIME:
				var tile_data = current_tile_data() #func lower in script
				if tile_data != null:
					finish_dig() #next func in scipt
		else:
			cancel_dig() #func lower in script
	
	#if in rubbish scene, if bins reach ten, spawn item at player pos
	if Globals.items_in_metal > 10:
		spawn_objective_tools(2)

func finish_dig():#physics_process
	var tile= local_to_map(get_global_mouse_position())
	set_cell(tile, 0, Vector2i(-1,-1))#remove the tile
	spawn_random_items(4) #lower in script
	dig_progress = 0.0 #reset digging time
	$"../RubbishDug".play()
		
func cancel_dig():#physics_process
	dig_progress = 0.0

	
func spawn_random_items(count):#finish_dig
	var spawned_count = 0
	while spawned_count < count:
		spawn_item(Globals.spawnable_rubbish_items[randi() % Globals.spawnable_rubbish_items.size()], position)
		spawned_count += 1
		
func spawn_item(data, position):#physics_process
	var item_scene = preload("res://scenes/InventoryItem.tscn")
	var item_instance = item_scene.instantiate()
	var mouse_pos = get_global_mouse_position()#get_drop_position()
	item_instance.initiate_items(data["type"], data["name"], data["effect"], data["texture"]) # gives to/takes from inventory item
	item_instance.global_position = mouse_pos #items spawn position is the mouse's current position
	items_node.add_child(item_instance)
	
func spawn_objective_tools(i): #change i depending on objective 
	spawn_objective_tool_data(Globals.objective_tools[i], position)

func spawn_objective_tool_data(data, position):#takes data, position always infont of the spaceship
	var item_scene = preload("res://scenes/InventoryItem.tscn")
	var item_instance = item_scene.instantiate()
	item_instance.initiate_items(data["type"], data["name"], data["effect"], data["texture"]) # gives to/takes from inventory item
	if data["name"] == "empty": #if is empty bucket, spawn at spaceship ###relates to inventory slot ui, on_use_button_pressed
		item_instance.global_position = Vector2(343,305)
	elif data["name"] == "filled" and Globals.reached_water == true: #if filled bucket, spawn at players feet
		item_instance.global_position = Globals.player_global_position + Vector2(0,1)
	else:
		item_instance.global_position = Globals.player_global_position + Vector2(0,0.1)
	items_node.add_child(item_instance)
	

func current_tile_data():#physics_process, checking is there is still a tile in the tile map at the mouse postition
	var mouse_pos = get_global_mouse_position() #godot function
	var tile_pos: Vector2i = rubbishtile.local_to_map(rubbishtile.to_local(mouse_pos))
	var tile_data = rubbishtile.get_cell_tile_data(tile_pos) #godot func
	return tile_data

	
	
