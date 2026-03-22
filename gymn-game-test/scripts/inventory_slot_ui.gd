extends Panel

@onready var icon = $SlotImage/ItemIcon
@onready var quantity_label = $SlotImage/ItemQuantity
@onready var details_panel = $DetailsPanel
@onready var item_name = $DetailsPanel/ItemName 
@onready var item_type = $DetailsPanel/ItemType
@onready var item_effect = $DetailsPanel/ItemEffect
@onready var usage_panel = $UsagePanel
@onready var assign_button = $UsagePanel/AssignButton
@onready var rubbishsort = get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_node("CanvasLayer/RubbishSort")
@onready var rubbish_pile_tile_scene = get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_node("Environment/Rubbish/RubbishPileTile")
@onready var border_slot = $SlotImage
						#use this to spawn in filled waterbucket, used in on_use_button_pressed
var item = null
var drop_position
var slot_index = -1 #item does not exist and has no position in hotbar
var is_assigned = false #has the item been assisned to the hotbar?

signal drag_start(slot)
signal drag_end()

func set_slot_index(new_index):#setting index
	slot_index = new_index

func _on_item_button_mouse_entered() -> void:
	if item != null: #if there is an item (while hovering), hide usagepanel open setails panel
		usage_panel.visible = false
		details_panel.visible = true

func _on_item_button_mouse_exited() -> void:
	details_panel.visible = false #(no longer hovering)

func set_empty(): #inventory ui
	icon.texture = null #make item_slot empty
	quantity_label.text = ""

func set_item(new_item):# inventorty_ui, collects data to add to inventory
	item = new_item
	icon.texture = new_item["texture"]
	quantity_label.text = str(item["quantity"])
	item_name.text = str(item["name"])
	item_type.text = str(item["type"])
	if item["effect"] != "":
		item_effect.text = str("+ ", item["effect"])
	else:
		item_effect.text = "No effect"
		
	update_assignment_status()#is the item assigned to hotbar or not?
	
func _on_drop_button_pressed() -> void: #button on inventory when the inventory slot is clicked
		drop_position =  Globals.player_node.global_position #drop_position empty variable above. player_node set as astro in globals. 
		var drop_offset = Vector2(0,0) #make the offset have an x and y position
		drop_offset = drop_offset.rotated(Globals.player_node.rotation) #rotate the (x,y) around the player
		Globals.drop_item(item, drop_position + drop_offset) #Tells func in globals the items data and position with the new rotation. 
		Globals.remove_items(item["type"], item["effect"], item["name"]) #removes fom inventory, globals
		Globals.remove_hotbar_item(item["type"], item["effect"], item["name"])
		usage_panel.visible = false #this script

func _on_use_button_pressed() -> void:#button on inventory when the inventory slot is clicked
	usage_panel.visible = false
	
	if item != null and item["effect"] != "" : #omly if the item has an effect
		if Globals.player_node:
			if Globals.reached_water: #if by water source
				Globals.player_node.apply_item_effect(item) #apply effect to player from astro script
				Globals.remove_items(item["type"], item["effect"], item["name"]) #globals, remove from inventory
				Globals.remove_hotbar_item(item["type"], item["effect"], item["name"])
				
				if item["effect"] == "fill": #if empty waterbucket
					rubbish_pile_tile_scene.spawn_objective_tools(1)#fill with water
			else:
				if item["effect"] != "fill":
					Globals.player_node.apply_item_effect(item)	
					Globals.remove_items(item["type"], item["effect"], item["name"]) #globals, remove from inventory
					Globals.remove_hotbar_item(item["type"], item["effect"], item["name"])
				#alltså, when the bucket cannot be filled with water, do not remove the bucket from inventory
		else:
			print("Player not found") #avoiding crashing

func update_assignment_status(): #updates hotbar assignment
	is_assigned = Globals.is_item_assigned_to_hotbar(item)
	if is_assigned: 
		assign_button.text = "unassign"
	else:
		assign_button.text = "assign"

func _on_assign_button_pressed() -> void:
	if item != null:
		if is_assigned: #if we want to remove item from hotbar
			Globals.unassign_hotbar_item(item["type"], item["effect"], item["name"])
			is_assigned = false
		else: #otherwise, the player wants to add to hotbar
			Globals.add_items(item, true)
			is_assigned = true
		update_assignment_status()	

func _on_item_button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed(): #usage panel
			if item != null: #if there is an item (clicked button), show the usage panel
				usage_panel.visible = !usage_panel.visible
		if event.button_index == MOUSE_BUTTON_RIGHT:#moveing arounf item in slot
			if event.is_pressed():
				border_slot.modulate = Color(0.8, 1, 0.9)
				drag_start.emit(self)
			else:
				border_slot.modulate = Color(1, 1, 1)
				drag_end.emit()
			
