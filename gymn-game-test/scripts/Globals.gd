extends Node

var rubbish_sort_visible := false #inv item scene
var player_global_position: Vector2
var inventory =[]
var reached_water = false#for objective
var is_dragging := false# used in inv item, for dragging items in rubbish sort
var spawnable_rubbish_items = [ #used in rubbish_pile_tile scene, spawn_random_items func
	{"type": "metal", "name": "metal plates", "effect": "", "texture": preload("res://assets/bits and bobs/PostApocalypse_AssetPack_v1/Objects/general rubbish/Metal-Plates.png")},
	{"type": "wood", "name": "palet1", "effect": "", "texture": preload("res://assets/bits and bobs/PostApocalypse_AssetPack_v1/Objects/general rubbish/Pallet_1.png")},
	{"type": "metal", "name": "exhaust", "effect": "", "texture": preload("res://assets/bits and bobs/PostApocalypse_AssetPack_v1/Objects/general rubbish/Exhaust-pipe.png")},
	{"type": "wood", "name": "palet2", "effect": "", "texture": preload("res://assets/bits and bobs/PostApocalypse_AssetPack_v1/Objects/general rubbish/Pallet_2.png")},
	{"type": "plastic", "name": "cone", "effect": "", "texture": preload("res://assets/bits and bobs/PostApocalypse_AssetPack_v1/Objects/road stuff/Traffic-cone.png")},	
	{"type": "plastic", "name": "packet", "effect": "", "texture": preload("res://assets/bits and bobs/PostApocalypse_AssetPack_v1/Objects/general rubbish/Chips-pack_Yellow.png")},
	{"type": "fruit", "name": "apple", "effect": "speed", "texture": preload("res://assets/bits and bobs/Food/Fruit_apple.png")}, 
	{"type": "tree", "name": "seeds", "effect": "plant", "texture": preload("res://assets/bits and bobs/objective tools/seeds.png")}
]

var objective_bar_list = [
	preload("res://assets/bits and bobs/objective tools/Bar images/empty_bar.png"),
	preload("res://assets/bits and bobs/objective tools/Bar images/1:4 bar.png"),
	preload("res://assets/bits and bobs/objective tools/Bar images/1:2 bar.png"),
	preload("res://assets/bits and bobs/objective tools/Bar images/3:4 bar.png"),
	preload("res://assets/bits and bobs/objective tools/Bar images/full_bar.png"), 
]

var objective_tools = [{"type": "bucket", "name": "empty", "effect": "fill", "texture": preload("res://assets/bits and bobs/objective tools/Bucket2.png")},
	{"type": "bucket", "name": "filled", "effect": "water", "texture": preload("res://assets/bits and bobs/objective tools/water_bucket.png")},
	{"type": "ingot", "name": "metal", "effect": "", "texture": preload("res://assets/bits and bobs/objective tools/metal_ingot.png")},
	{"type": "ingot", "name": "plastic", "effect": "", "texture": preload("res://assets/bits and bobs/objective tools/plasic_ingot.png")},
	{"type": "can", "name": "watering", "effect": "", "texture": preload("res://assets/bits and bobs/objective tools/watering_can.png")},
	{"type": "axe", "name": "wooden", "effect": "cut", "texture": preload("res://assets/bits and bobs/objective tools/wood axe.png")},
	{"type": "fruit", "name": "plum", "effect": "mining", "texture": preload("res://assets/bits and bobs/objective tools/plum.png")}
	]

signal inventory_updated #whenever an item is added or removed, update the inventory 


@onready var inventory_slot_scene = preload("res://GUI/inventory_slot.tscn") #need the scene to add/ remove from slots used in inventory ui, _on_inv_updated()
@onready var rubbish_sort_scene = preload("res://scenes/rubbish_sort.tscn") #connected in _ready in level and then 
#instantiated variable set a empty and then updated to instantiated rubbish_sort_scene in _ready in level
@onready var level_scene = preload("res://scenes/level.tscn")

var player_node : Astro = null #set player as player from player scene
var rubbishsort_instance: Node = null #used in function get_drop_variable at end of Globals script
var level_instance: Node = null

#rubbish sort
var is_inside_wood = false
var is_inside_plastic = false
var is_inside_metal = false
var old_items_inside_wood := 0
var items_in_wood := 0
var old_items_inside_metal := 0
var items_in_metal := 0
var old_items_inside_plastic := 0
var items_in_plastic := 0

#tree
var seeds_used = false
var grow_tree = false
var spawned_tree = false
var player_in_tree_range = false
var tree_cut = false

#winning factors
var trees_fully_grown = 0
var no_tiles = false
var has_won = false
var won = false

var dig_time = 2

var objectives_completed = 0 #objective scene
var invno := 0 #for objective
var objective = 1
var objective_1_complete = false #_process will make bucket spawn in 60 fps making hundreds of buckets
#globals invo(objects collected) stays true and buckets spawn in . but creating a variable and then changing it, it only runs once

#hotbar
var hotbar_size = 5
var hotbar_inventory = []

func _ready() -> void:
	inventory.resize(15) #inventory list has 15 spaces
	hotbar_inventory.resize(hotbar_size)
	
func add_items(item, to_hotbar = false):
	
	var added_to_hotbar = false
	
	if to_hotbar: #if we want to add the item to the hotbar
		added_to_hotbar = add_hotbar_item(item)
		inventory_updated.emit()
	if not to_hotbar: #else add to inventory
		for i in range(15): #cannot exeed 15 items in inventory
			#if there is already an item in the inventory then you + the quantity of the item only depending on effect and type
			if inventory[i] != null and inventory[i]["name"] == item["name"] and inventory[i]["effect"] == item["effect"]:
				inventory[i]["quantity"] += item["quantity"] #if item exists, add one more item
				invno += 1 #for objective scene
				inventory_updated.emit()
				return true
			# if you are adding smth new to the inventory
			elif inventory[i] == null:
				inventory[i] = item
				inventory_updated.emit()
				invno += 1
				return true
		#if there isnt any space in the inventory or smth dont pick up
		return false

func remove_items(item_type, item_effect, item_name):
	for i in range(inventory.size()):
		if inventory[i] != null and inventory[i]["type"] == item_type and inventory[i]["effect"] == item_effect and inventory[i]["name"] == item_name:
			inventory[i]["quantity"] -= 1
			invno -= 1
			if inventory[i]["quantity"] <= 0:
				inventory[i] = null
			inventory_updated.emit()
			return true
	return false

func increase_inventory_size():
	inventory_updated.emit

func set_player_reference(player):
	player_node = player #vector2D is now set as the player

func ajust_drop_position(position):# in a range around the character place item around character randomly 
	var radius = 7
	var nearby_items = get_tree().get_nodes_in_group("Items") 
	for item in nearby_items:
		if item.global_position.distance_to(position) < radius:
			var random_offset = Vector2(randf_range(-radius,radius),randf_range(-radius,radius))
			position += random_offset
			break
	return position

func drop_item(item_data, drop_position):
	var items_node = level_instance.get_node("Items")
	var sort_items_node = rubbishsort_instance.get_node("Items_sort")
	
	var item_scene = load(item_data["scene_path"])#inventory_item scene: pickup()
	var item_instance = item_scene.instantiate()
	item_instance.set_item_data(item_data)# inventory item scene, get data from that scene path
	drop_position = get_drop_position()# next func
	item_instance.global_position = drop_position # set the global position of the item as the position just created
	#get_tree().current_scene.add_child(item_instance) #add item to scene (Where?? ToT)
	
	
	if rubbish_sort_visible == false:
		get_tree().current_scene.get_node("Items").add_child(item_instance) #if sorting is not active, add to map
	else:
		get_tree().current_scene.get_node("CanvasLayer/RubbishSort/Items_sort").add_child(item_instance)# otherwise add to sorting scene
		item_instance.add_to_group("sorting_items")
	
func get_drop_position() -> Vector2:
	var drop_position: Vector2 # drop position created, a vector
	if rubbish_sort_visible == true: #updated in level scene, created in globals, right at top
		drop_position = get_random_area_within_drop_area() #func below
	
	else:
		drop_position  = player_node.global_position # if sorting scene is not visible, the drop position
													#is not a vector but the character, cuz items drop around player
		drop_position = ajust_drop_position(drop_position)#funcs above
		
	return drop_position
	
func get_random_area_within_drop_area():
	var drop_variables = get_drop_variables() # func below
	var drop_area: Area2D = drop_variables[0] #take 1st info from list
	var drop_box: CollisionShape2D = drop_variables[1] #take 2nd info from list
	
	var shape := drop_box.shape as RectangleShape2D #tells godot to read as a rectangle
	var extents: Vector2 = shape.extents # takes coordinates, cuts them in half 
	
	var x := randf_range(-extents.x, extents.x) #half the coordinates in one direction,
	var y := randf_range(-extents.y, extents.y) #and half in the other direction - negative

	return drop_area.to_global(Vector2(x, y)) #coordinate for dropped item, global so that they come up on the screen

func get_drop_variables()	:
	var droparea = rubbishsort_instance.get_node("DropArea") #rubbishsort_instance set as empty node in top of globals
	var dropbox = rubbishsort_instance.get_node("DropArea/DropBox")#and them updates in rubbishsort scene as self
	return [droparea, dropbox] #get variables in a list cuz cant return it any other way :D
	
func add_hotbar_item(item):
	for i in range(hotbar_size): #if an item doesnt exist
		if hotbar_inventory[i] == null:
			hotbar_inventory[i] = item
			return true
	return false
	
#removes item from hotbar to ground
func remove_hotbar_item(item_type, item_effect, item_name):
	for i in range(hotbar_inventory.size()):
		if hotbar_inventory[i] != null and hotbar_inventory[i]["type"] == item_type and hotbar_inventory[i]["effect"] == item_effect and hotbar_inventory[i]["name"] == item_name:
			if hotbar_inventory[i]["quantity"] <= 0:
				hotbar_inventory[i] = null
			inventory_updated.emit()
			return true
	return false
	
#removes item from hotbar to inventory
func unassign_hotbar_item(item_type, item_effect, item_name):
	for i in range(hotbar_inventory.size()):
		if hotbar_inventory[i] != null and hotbar_inventory[i]["type"] == item_type and hotbar_inventory[i]["effect"] == item_effect and hotbar_inventory[i]["name"] == item_name:
			hotbar_inventory[i] = null
			inventory_updated.emit()
			return true
	return false
	
func is_item_assigned_to_hotbar(item_to_check):#avoid adding the same item to hotbar, multiple times (duplication)
	return item_to_check in hotbar_inventory
	
func swap_inventory_items(index1, index2): #swapping inventory items
	if index1 < 0 or index1 > inventory.size() or index2 < 0 or index2 > inventory.size():
		return false
	var temp = inventory[index1] #temporary variable while swapping
	inventory[index1] = inventory[index2]
	inventory[index2] = temp
	inventory_updated.emit()
	return true
	
func swap_hotbar_items(index1, index2): #swapping inventory items
	if index1 < 0 or index1 > inventory.size() or index2 < 0 or index2 > inventory.size():
		return false
	var temp = hotbar_inventory[index1] #temporary variable while swapping
	hotbar_inventory[index1] = hotbar_inventory[index2]
	hotbar_inventory[index2] = temp
	inventory_updated.emit()
	return true	
	
func reset():
	if Globals.won == true:
		inventory_updated.emit()
