extends Node

var rubbish_sort_visible := false
var player_global_position: Vector2
var inventory =[]
var invno := 0 #for objective
var spawnable_rubbish_items = [
	{"type": "metal", "name": "metal plates", "effect": "", "texture": preload("res://assets/bits and bobs/PostApocalypse_AssetPack_v1/Objects/general rubbish/Metal-Plates.png")},
	{"type": "wood1", "name": "palet1", "effect": "", "texture": preload("res://assets/bits and bobs/PostApocalypse_AssetPack_v1/Objects/general rubbish/Pallet_1.png")},
	{"type": "wood2", "name": "palet2", "effect": "", "texture": preload("res://assets/bits and bobs/PostApocalypse_AssetPack_v1/Objects/general rubbish/Pallet_2.png")},
	{"type": "metal", "name": "exhaust", "effect": "", "texture": preload("res://assets/bits and bobs/PostApocalypse_AssetPack_v1/Objects/general rubbish/Exhaust-pipe.png")},
	{"type": "plastic", "name": "cone", "effect": "", "texture": preload("res://assets/bits and bobs/PostApocalypse_AssetPack_v1/Objects/road stuff/Traffic-cone.png")},	
]

signal inventory_updated #whenever an item is added or removed, update the inventory 

var player_node : Astro = null #set player as player from player scene
@onready var inventory_slot_scene = preload("res://GUI/inventory_slot.tscn") #need the scene to add/ remove from slots used in inventory ui, _on_inv_updated()
@onready var rubbish_sort_scene = preload("res://scenes/rubbish_sort.tscn") #connected in _ready in level and then 
#instantiated variable set a empty and then updated to instantiated rubbish_sort_scene in _ready in level
var rubbishsort_instance: Node = null #used in function get_drop_variable at end of Globals script

func _ready() -> void:
	inventory.resize(15) #inventory list has 15 spaces
	
func add_items(item):
	for i in range(15): #cannot exeed 15 items in inventory
		#if there is already an item in the inventory then you + the quantity of the item only depending on effect and type
		if inventory[i] != null and inventory[i]["type"] == item["type"] and inventory[i]["effect"] == item["effect"]:
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

func remove_items(item_type, item_effect):
	for i in range(inventory.size()):
		if inventory[i] != null and inventory[i]["type"] == item_type and inventory[i]["effect"] == item_effect:
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
	var item_scene = load(item_data["scene_path"])#inventory item scene: pickup()
	var item_instance = item_scene.instantiate()
	item_instance.set_item_data(item_data)# inventory item scene, get data from that scene path
	drop_position = get_drop_position()# next func
	item_instance.global_position = drop_position # set the global position of the item as the position just created
	get_tree().current_scene.add_child(item_instance) #add item to scene
	
func get_drop_position() -> Vector2:
	var drop_position : Vector2 # drop position created, a cevtor
	if rubbish_sort_visible == true: #updated in level scene, created in globals, right at top
		drop_position = get_random_area_within_drop_area() #func below
	
	else:
		drop_position  = player_node.global_position # if sorting scene is not visible, the drop position
													#is not a vector but the character, cuz items drop around player
		drop_position = ajust_drop_position(drop_position)#funcs above
		
	return drop_position
	
func get_random_area_within_drop_area():
	var drop_variables = get_drop_variables() # func below
	var drop_box: CollisionShape2D = drop_variables[1] #take 2nd info from list
	var drop_area: Area2D = drop_variables[0] #take 1st info from list
	
	var area_rect: Rect2 = drop_box.shape.get_rect() #create variable that gets the rectangle of drop_box
	var x = randf_range(0, area_rect.position.x) # pick a random x from 0 - the position of the x of the rectangle
	var y = randf_range(0, area_rect.position.y)

	return drop_area.to_global(Vector2(x,y))	#drop items on randomly generated drop area

func get_drop_variables()	:
	var droparea = rubbishsort_instance.get_node("DropArea") #rubbishsort_instance set as empty node in top of globals
	var dropbox = rubbishsort_instance.get_node("DropArea/DropBox")#and them updates in rubbishsort scene as self
	return [droparea, dropbox] #get variables in a list cuz cant return it any other way :D
	
	
