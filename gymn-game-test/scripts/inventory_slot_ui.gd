extends Panel

@onready var icon = $SlotImage/ItemIcon
@onready var quantity_label = $SlotImage/ItemQuantity
@onready var details_panel = $DetailsPanel
@onready var item_name = $DetailsPanel/ItemName 
@onready var item_type = $DetailsPanel/ItemType
@onready var item_effect = $DetailsPanel/ItemEffect
@onready var usage_panel = $UsagePanel

var item = null

func _on_item_button_pressed() -> void:
	if item != null:
		usage_panel.visible = !usage_panel.visible

func _on_item_button_mouse_entered() -> void:
	if item != null:
		usage_panel.visible = false
		details_panel.visible = true

func _on_item_button_mouse_exited() -> void:
	details_panel.visible = false

func set_empty():
	icon.texture = null
	quantity_label.text = ""

func set_item(new_item):
	item = new_item
	icon.texture = new_item["texture"]
	quantity_label.text = str(item["quantity"])
	item_name.text = str(item["name"])
	item_type.text = str(item["type"])
	if item["effect"] != "":
		item_effect.text = str("+ ", item["effect"])
	else:
		item_effect.text = ""
	

func _on_drop_button_pressed() -> void:
	if item != null:
		var drop_position = Globals.player_node.global_position
		var drop_offset = Vector2(0,0)
		drop_offset = drop_offset.rotated(Globals.player_node.rotation)
		Globals.drop_item(item, drop_position + drop_offset)
		Globals.remove_items(item["type"], item["effect"])
		usage_panel.visible = false


func _on_use_button_pressed() -> void:
	usage_panel.visible = false
	
	if item != null and item["effect"] != "":
		if Globals.player_node:
			Globals.player_node.apply_item_effect(item)
			Globals.remove_items(item["type"], item["effect"])
		else:
			print("Player not found")
		
