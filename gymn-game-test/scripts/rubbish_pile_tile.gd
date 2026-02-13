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

func finish_dig():#physics_process
	var tile= local_to_map(get_global_mouse_position())
	set_cell(tile, 0, Vector2i(-1,-1))#remove the tile
	spawn_random_items() #lower in script
	dig_progress = 0.0 #reset digging time

		
func cancel_dig():#physics_process
	dig_progress = 0.0

	
func spawn_random_items():#physics_process
	var spawned_count = 0
	while spawned_count < 3:
		spawn_item(Globals.spawnable_rubbish_items[randi() % Globals.spawnable_rubbish_items.size()], position)
		spawned_count += 1
	

func spawn_item(data, position):#physics_process
	var item_scene = preload("res://scenes/InventoryItem.tscn")
	var item_instance = item_scene.instantiate()
	var mouse_pos = get_global_mouse_position()#get_drop_position()
	item_instance.initiate_items(data["type"], data["name"], data["effect"], data["texture"]) # gives to/takes from inventory item
	item_instance.global_position = mouse_pos #items spawn position is the mouse's current position
	
	if Globals.rubbish_sort_visible == false:
		items_node.add_child(item_instance) #if sorting is not active, add to map
	else:
		sort_items_node.add_child(item_instance)# otherwise add to sorting scene

func current_tile_data():#physics_process, checking is there is still a tile in the tile map at the mouse postition
	var mouse_pos = get_global_mouse_position() #godot function
	var tile_pos: Vector2i = rubbishtile.local_to_map(rubbishtile.to_local(mouse_pos))
	var tile_data = rubbishtile.get_cell_tile_data(tile_pos) #godot func
	return tile_data

	
	
