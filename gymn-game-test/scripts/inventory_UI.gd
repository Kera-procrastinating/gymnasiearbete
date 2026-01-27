extends Control

@onready var grid_container = $NinePatchRect/GridContainer

func _ready() -> void:
	Globals.inventory_updated.connect(_on_inv_updated)
	_on_inv_updated()


func _on_inv_updated():
	#if none of item, add to inv
	#if item in inv, clear items
	#remove/add items
	#reload with -/+ items 
	clear_grid_container()
	for item in Globals.inventory:
		var slot = Globals.inventory_slot_scene.instantiate()
		grid_container.add_child(slot)
		if item != null:
			slot.set_item(item)
		else:
			slot.set_empty()
		


#remove duplicates
func clear_grid_container():
	while grid_container.get_child_count() > 0:
		var child = grid_container.get_child(0)
		grid_container.remove_child(child)
		child.queue_free()
		
