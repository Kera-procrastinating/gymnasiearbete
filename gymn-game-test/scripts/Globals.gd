extends Node

###########player###################
var player_global_position: Vector2

#############inventory#####################

var inventory =[]
var invno := 0
var spawnable_rubbish_items = [
	{"type": "metal", "name": "metal plates", "effect": "", "texture": preload("res://assets/bits and bobs/PostApocalypse_AssetPack_v1/Objects/general rubbish/Metal-Plates.png")},
	{"type": "wood", "name": "palet", "effect": "", "texture": preload("res://assets/bits and bobs/PostApocalypse_AssetPack_v1/Objects/general rubbish/Pallet_1.png")},
	{"type": "wood", "name": "palet", "effect": "", "texture": preload("res://assets/bits and bobs/PostApocalypse_AssetPack_v1/Objects/general rubbish/Pallet_2.png")},
	{"type": "metal", "name": "exhaust", "effect": "", "texture": preload("res://assets/bits and bobs/PostApocalypse_AssetPack_v1/Objects/general rubbish/Exhaust-pipe.png")},
	{"type": "plastic", "name": "cone", "effect": "", "texture": preload("res://assets/bits and bobs/PostApocalypse_AssetPack_v1/Objects/road stuff/Traffic-cone.png")},	
]

signal inventory_updated

var player_node : Node = null
@onready var inventory_slot_scene = preload("res://GUI/inventory_slot.tscn")


func _ready() -> void:
	inventory.resize(15)
	
func add_items(item):
	for i in range(inventory.size()):
		#if there is already an item in the inventory then you + the quantity of the item
		if inventory[i] != null and inventory[i]["type"] == item["type"] and inventory[i]["effect"] == item["effect"]:
			inventory[i]["quantity"] += item["quantity"]
			invno += 1
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
	player_node = player

func ajust_drop_position(position):
	var radius = 7
	var nearby_items = get_tree().get_nodes_in_group("Items")
	for item in nearby_items:
		if item.global_position.distance_to(position) < radius:
			var random_offset = Vector2(randf_range(-radius,radius),randf_range(-radius,radius))
			position += random_offset
			break
	return position
	
func drop_item(item_data, drop_position):
	var item_scene = load(item_data["scene_path"])
	var item_instance = item_scene.instantiate()
	item_instance.set_item_data(item_data)
	drop_position = ajust_drop_position(drop_position)
	item_instance.global_position = drop_position
	get_tree().current_scene.add_child(item_instance)
	
	
	
