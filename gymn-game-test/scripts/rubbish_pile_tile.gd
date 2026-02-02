extends TileMapLayer
class_name rubbish_scene

const DIGGING_RANGE := 15
const DIG_TIME := 0.75

var dig_progress := 0.0
var digging := false

#@onready var items = $Items
@onready var items_node = get_parent().get_parent().get_parent().get_node("Items")
@onready var rubbishtile = $"."

func _physics_process(delta: float) -> void:
	
	if (Globals.player_global_position.distance_to(get_global_mouse_position())< DIGGING_RANGE):
		
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			dig_progress += delta
			
			if dig_progress >= DIG_TIME:
				var tile_data = current_tile_data()
				if tile_data != null:
					finish_dig()
				
		else:
			cancel_dig()

func finish_dig():
	digging = false
	var tile= local_to_map(get_global_mouse_position())
	set_cell(tile, 0, Vector2i(-1,-1))#remove the tile
	### drop item ### smth to do w tile variable
	spawn_random_items()
	dig_progress = 0.0

		
func cancel_dig():
	digging = false
	dig_progress = 0.0

	
func spawn_random_items():
	var spawned_count = 0
	while spawned_count < 3:
		spawn_item(Globals.spawnable_rubbish_items[randi() % Globals.spawnable_rubbish_items.size()], position)
		spawned_count += 1
	

func spawn_item(data, position):
	var item_scene = preload("res://scenes/InventoryItem.tscn")
	var item_instance = item_scene.instantiate()
	var mouse_pos = get_global_mouse_position()#get_drop_position()
	item_instance.initiate_items(data["type"], data["name"], data["effect"], data["texture"])
	item_instance.global_position = mouse_pos
	items_node.add_child(item_instance)
	

func current_tile_data():
	var mouse_pos = get_global_mouse_position()
	var tile_pos: Vector2i = rubbishtile.local_to_map(rubbishtile.to_local(mouse_pos))
	var tile_data = rubbishtile.get_cell_tile_data(tile_pos)
	return tile_data

	
	
