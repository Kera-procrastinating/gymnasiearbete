extends Control

var dragged_slot = null

@onready var hotbar_container = $TextureRect/HBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.inventory_updated.connect(_update_hotbar_ui)
	_update_hotbar_ui()

func _update_hotbar_ui(): #create the hotbar slots
	clear_hotbar_container()
	for i in range(Globals.hotbar_size):
		var slot = Globals.inventory_slot_scene.instantiate()
		slot.set_slot_index(i)
		
		slot.drag_start.connect(_on_drag_start)
		slot.drag_end.connect(_on_drag_end)
		
		hotbar_container.add_child(slot)
		if Globals.hotbar_inventory[i] != null:
			slot.set_item(Globals.hotbar_inventory[i])
		else:
			slot.set_empty()
		slot.update_assignment_status()#assign correct text to hotbar when item is assigned
		
	
func clear_hotbar_container(): #clear hotbar slots
	while hotbar_container.get_child_count() > 0:
		var child = hotbar_container.get_child(0)
		hotbar_container.remove_child(child)
		child.queue_free()
		
func _on_drag_start(slot_control : Control):
	dragged_slot = slot_control
	
func _on_drag_end():
	var target_slot = get_slot_under_mouse()
	if target_slot and dragged_slot != target_slot:
		drop_slot(dragged_slot, target_slot)
	dragged_slot = null


func get_slot_under_mouse() -> Control: #get the slot position that the mouse is hovering over, else null
	var mouse_position = get_global_mouse_position()
	for slot in hotbar_container.get_children():
		var slot_rect = Rect2(slot.global_position, slot.size)
		if slot_rect.has_point(mouse_position):
			return slot
	return null

func get_slot_index(slot: Control) -> int:
	for i in range(hotbar_container.get_child_count()):
		if hotbar_container.get_child(i) == slot:
			return i #if valid slot was found
	return -1 #invalid slot

func drop_slot(slot1: Control, slot2: Control):
	var slot1_index = get_slot_index(slot1)
	var slot2_index = get_slot_index(slot2)
	
	if slot1_index == -1 or slot2_index == -1:
		return #invalid slots found
	else:
		Globals.swap_hotbar_items(slot1_index, slot2_index)
		_update_hotbar_ui()
