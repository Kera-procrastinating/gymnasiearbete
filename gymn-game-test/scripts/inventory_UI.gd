extends Control

@onready var grid_container = $NinePatchRect/GridContainer

var dragged_slot = null

func _ready() -> void:
	load_slots()
	
func load_slots():
	Globals.inventory_updated.connect(_on_inv_updated)
	_on_inv_updated()

func _on_inv_updated():#signal, every time signal is calles, play code
	clear_grid_container() # next func 
	for item in Globals.inventory:
		var slot = Globals.inventory_slot_scene.instantiate() #activate slot scene
		slot.drag_start.connect(_on_drag_start)
		slot.drag_end.connect(_on_drag_end)
		
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
		
func _on_drag_start(slot_control : Control):
	dragged_slot = slot_control
	
func _on_drag_end():
	var target_slot = get_slot_under_mouse()
	if target_slot and dragged_slot != target_slot:
		drop_slot(dragged_slot, target_slot)
	dragged_slot = null


func get_slot_under_mouse() -> Control: #get the slot position that the mouse is hovering over, else null
	var mouse_position = get_global_mouse_position()
	for slot in grid_container.get_children():
		var slot_rect = Rect2(slot.global_position, slot.size)
		if slot_rect.has_point(mouse_position):
			return slot
	return null

func get_slot_index(slot: Control) -> int:
	for i in range(grid_container.get_child_count()):
		if grid_container.get_child(i) == slot:
			return i #if valid slot was found
	return -1 #invalid slot

func drop_slot(slot1: Control, slot2: Control):
	var slot1_index = get_slot_index(slot1)
	var slot2_index = get_slot_index(slot2)
	
	if slot1_index == -1 or slot2_index == -1:
		return #invalid slots found
	else:
		Globals.swap_inventory_items(slot1_index, slot2_index)
		_on_inv_updated()
