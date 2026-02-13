extends Control

@onready var grid_container = $NinePatchRect/GridContainer

func _ready() -> void:
	Globals.inventory_updated.connect(_on_inv_updated)
	_on_inv_updated()

func _on_inv_updated():#signal, every time signal is calles, play code
	clear_grid_container() # next func 
	for item in Globals.inventory:
		var slot = Globals.inventory_slot_scene.instantiate() #activate slot scene
		grid_container.add_child(slot) #add item as slot item in inventory
		if item != null: # if item is being added
			slot.set_item(item) #inventory_slot, takes vitem data
		else:# if item is being removed
			slot.set_empty() #inventory slot, clears texture and label

func clear_grid_container():#when the inventory is to be updates, it clears all the slots so that they can be reset.
	while grid_container.get_child_count() > 0: #while there are more than 0 (item in the)slots in the grid, until completely empty
		var child = grid_container.get_child(0) 
		grid_container.remove_child(child) #remove the slots 
		child.queue_free()#delete once optimal
		
