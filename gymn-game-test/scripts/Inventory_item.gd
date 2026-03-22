@tool #helps with automation of repetative tasks, in this case spawning different items
extends Node2D

# @export makes so that it will exist on the items granskare
@export var item_type = ""
@export var item_name = ""
@export var item_texture: Texture
@export var item_effect = ""
@onready var icon_sprite = $Sprite2D
@onready var pickup_audio = $PickupAudio
@onready var item = $"."
@onready var items_sort_node = get_parent().get_parent().get_node("CanvasLayer/RubbishSort/Items_sort")
@onready var body_ref_wood = get_parent().get_parent().get_node("WoodArea")
@onready var body_ref_metal = $MetalArea
@onready var body_ref_plastic = $DropArea
@onready var metal_bin_audio = get_parent().get_parent().get_node("Bins/Metal/MetalDropSound")
@onready var wood_bin_audio = get_parent().get_parent().get_node("Bins/Wood/WoodDropSound")
@onready var plastic_bin_audio = get_parent().get_parent().get_node("Bins/Plastic/PlasticDropSound")


#scene_path ##############################################################################
var scene_path: String = "res://scenes/InventoryItem.tscn"

#used in _on_area_2d_body_entered() later in this code, to determine if player in collision of dropped item
var player_in_range = false
var draggable = false #alltså, the mouse is over the item
var is_inside_dropable = false #interacts with the area2D of bin, rubbish_sort
var offset: Vector2
var initial_pos = Globals.get_random_area_within_drop_area()
 
func _ready() -> void:
	if not Engine.is_editor_hint(): #if game is being played, prepare texture
		icon_sprite.texture = item_texture

func _process(delta: float) -> void: 
	if Engine.is_editor_hint(): #for every frame in the editor...?
		icon_sprite.texture = item_texture #set texture
	if player_in_range and Input.is_action_just_pressed("pick_up"):
		pick_up_item() #func below, takes the items data
	
	#if Globals.rubbish_sort_visible == true:
		#if Globals.items_in_metal == 1:
			#pick_up_item() ######picks up ALL items
	
	
	if Globals.rubbish_sort_visible == true:
		item.scale = Vector2(50,50)
	else:
		if not item.is_in_group("sorting_items"):
			draggable = false #constatly?
			
		item.scale = Vector2(0.8, 0.8)
	
	

	#if adding specific object to inventory: spwan object on feet, immediately pickup
	
	sorting_rubbish()
	
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
		Globals.add_items(item, false) #add given item to inventory
		self.queue_free() #removes the item node after done loading all the data
		
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"): #if it is the player that entered (can find group next to granskare)
		player_in_range = true
		body.interact_ui.visible = true #interact_ui in astro scene controlls "press e to pickup"
		
	if body.is_in_group("dropable_wood"):
		is_inside_dropable = true

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

func scale_up(): #used in rubbish sort, to scle up the items when the scene is visible
	scale = Vector2(50, 50)
	

func _on_rubbish_sort_item_area_mouse_entered() -> void: #when mouse enters collision shape:
	if Globals.rubbish_sort_visible == true: #only while sorting
		if not Globals.is_dragging: #allows item to be dragged
			draggable = true
			scale = Vector2(51,51) #make slightly bigger

func _on_rubbish_sort_item_area_mouse_exited() -> void: #like previouse func
	if Globals.rubbish_sort_visible == true:
		if not Globals.is_dragging:
			draggable = false
			scale = Vector2(50,50)

func sorting_rubbish():
	if draggable:
		if Input.is_action_just_pressed("click"):
			offset = get_global_mouse_position() - global_position
			Globals.is_dragging = true
		if Input.is_action_pressed("click"):
			global_position = get_global_mouse_position() - offset
		elif Input.is_action_just_released("click"):
			Globals.is_dragging = false
			if item_type == "wood": #if item has type wood
				if Globals.is_inside_wood: #if is in bin area
					item.queue_free()
					Globals.items_in_wood += 1
					#wood_bin_audio.play()
			elif item_type == "metal": #if item has type wood
				if Globals.is_inside_metal:
					item.queue_free()
					Globals.items_in_metal += 1
					#metal_bin_audio.play()
			elif item_type == "plastic": #if item has type wood
				if Globals.is_inside_plastic:
					item.queue_free()
					Globals.items_in_plastic += 1
					#plastic_bin_audio.play()
