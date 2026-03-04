extends Panel

@onready var icon = $SlotImage/ItemIcon
@onready var quantity_label = $SlotImage/ItemQuantity
@onready var details_panel = $DetailsPanel
@onready var item_name = $DetailsPanel/ItemName 
@onready var item_type = $DetailsPanel/ItemType
@onready var item_effect = $DetailsPanel/ItemEffect
@onready var usage_panel = $UsagePanel
@onready var rubbishsort = get_parent().get_parent().get_parent().get_parent().get_node("RubbishSort")
@onready var rubbish_pile_tile_scene = get_parent().get_parent().get_parent().get_parent().get_parent().get_node("Environment/Rubbish/RubbishPileTile")
						#use this to spawn in filled waterbucket, used in on_use_button_pressed
var item = null
var drop_position

func _on_item_button_pressed() -> void:
	if item != null: #if there is an item (clicked button), show the usage panel
		usage_panel.visible = !usage_panel.visible

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
	
func _on_drop_button_pressed() -> void: #button on inventory when the inventory slot is clicked
		drop_position =  Globals.player_node.global_position #drop_position empty variable above. player_node set as astro in globals. 
		var drop_offset = Vector2(0,0) #make the offset have an x and y position
		drop_offset = drop_offset.rotated(Globals.player_node.rotation) #rotate the (x,y) around the player
		Globals.drop_item(item, drop_position + drop_offset) #Tells func in globals the items data and position with the new rotation. 
		Globals.remove_items(item["type"], item["effect"]) #removes fom inventory, globals
		usage_panel.visible = false #this script

func _on_use_button_pressed() -> void:#button on inventory when the inventory slot is clicked
	usage_panel.visible = false
	
	if item != null and item["effect"] != "" : #omly if the item has an effect
		if Globals.player_node:
			if Globals.reached_water: #if by water source
				Globals.player_node.apply_item_effect(item) #apply effect to player from astro script
				Globals.remove_items(item["type"], item["effect"]) #globals, remove from inventory
				
				if item["effect"] == "fill": #if empty waterbucket
					rubbish_pile_tile_scene.spawn_objective_tools(1)#fill with water
			else:
				if item["effect"] != "fill":
					Globals.player_node.apply_item_effect(item)	
					Globals.remove_items(item["type"], item["effect"]) #globals, remove from inventory
				#alltså, when the bucket cannot be filled with water, do not remove the bucket from inventory
		else:
			print("Player not found") #avoiding crashing
		

	
	
	
