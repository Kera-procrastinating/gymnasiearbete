extends Node2D

var inventoryUI = preload("res://GUI/inventory_gui.tscn") # show inv on layer
var inventoryUI_instance = inventoryUI.instantiate() #iniciate inventory to add to rubbish sort scene

@onready var inv_layer = $CanvasLayer #taken to globals
@onready var droparea = $DropArea #taken to globals (drop items in drop area)
@onready var dropbox = $DropArea/DropBoxv#taken to globals(tells code in globals where the area is located)
@onready var Items_sort_node = $Items_sort

func _ready() -> void:
	Globals.rubbishsort_instance = self #set the empty variable in globals to this scene, just to
	#be able to refenerce this scene in globals


func _on_drop_area_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
