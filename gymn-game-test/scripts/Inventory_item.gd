@tool #helps with automation of repetative tasks, in this case spawning different items
extends Node2D

# @export makes so that it will exist on the items granskare
@export var item_type = ""
@export var item_name = ""
@export var item_texture: Texture
@export var item_effect = ""
@onready var icon_sprite = $Sprite2D

#scene_path ##############################################################################
var scene_path: String = "res://scenes/InventoryItem.tscn"

#used in _on_area_2d_body_entered() later in this code, to determine if player in collision of dropped item
var player_in_range = false
 
func _ready() -> void:
	if not Engine.is_editor_hint(): #if game is being played, prepare texture
		icon_sprite.texture = item_texture

func _process(delta: float) -> void: 
	if Engine.is_editor_hint(): #for every fram in the editor...?
		icon_sprite.texture = item_texture #set texture
	
	if player_in_range and Input.is_action_just_pressed("pick_up"):
		pick_up_item() #func below, takes the items data
	
		
func pick_up_item():# used in globals when scene path is taken to load item scene
	var item = {
		"quantity": 1,
		"type": item_type,
		"name": item_name,
		"texture": item_texture,
		"effect": item_effect,
		"scene_path": scene_path
		}
		
	if Globals.player_node: #if there is a player (to avoid crashing)
		Globals.add_items(item) #add given item to inventory
		self.queue_free() #removes the item node after done loading all the data
		
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"): #if it is the player that entered (can find group next to granskare)
		player_in_range = true
		body.interact_ui.visible = true #interact_ui in astro scene controlls "press e to pickup"

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		body.interact_ui.visible = false


func set_item_data(data):#used in globals drop_item, takes from granskare(from this scene/code) and gives to drop item
	item_type = data["type"]
	item_name = data["name"]
	item_effect = data["effect"]
	item_texture = data["texture"]
	

func initiate_items(type, name, effect, texture):# used in rubbish_pile_tile script, spawn item, when dropping item
	item_type = type							#translates from r_p_t parameters back to inventory item data
	item_name = name
	item_effect = effect
	item_texture = texture
