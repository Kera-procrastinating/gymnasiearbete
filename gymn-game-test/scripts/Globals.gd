extends Node

###########player###################
var player_global_position: Vector2

#############inventory#####################

var inventory =[]

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
			inventory_updated.emit()
			print("item added", inventory)
			return true
		# if you are adding smth new to the inventory
		elif inventory[i] == null:
			inventory[i] = item
			inventory_updated.emit()
			print("item added", item)
			return true
	#if there isnt any space in the inventory or smth dont pick up
	return false
			
			

func remove_items():
	inventory_updated.emit
	
func increase_inventory_size():
	inventory_updated.emit
	
func set_player_reference(player):
	player_node = player
