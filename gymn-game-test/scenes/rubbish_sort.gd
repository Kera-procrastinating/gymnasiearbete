extends Node2D

var inventoryUI = preload("res://GUI/inventory_gui.tscn")
var inventoryUI_instance = inventoryUI.instantiate()

@onready var inv_layer = $CanvasLayer

func _process(delta: float) -> void:
	
	#Instance inventory
	show_inv_ui()
	#if item dragged into bin: take or reject 
		#drop items, new code for dropping in sorting room
		
	#if taken, add to smelt list. Smelt w machine
	
	
	pass

func show_inv_ui():
	var inventoryUI = preload("res://GUI/inventory_gui.tscn").instantiate()
	inv_layer.add_child(inventoryUI)
