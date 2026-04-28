extends Node2D

var inventoryUI = preload("res://GUI/inventory_gui.tscn") # show inv on layer
var inventoryUI_instance = inventoryUI.instantiate() #instantiate inventory to add to rubbish sort scene


@onready var inv_layer = $CanvasLayer #taken to globals
@onready var droparea = $DropArea #taken to globals (drop items in drop area)
@onready var dropbox = $DropArea/DropBoxv#taken to globals(tells code in globals where the area is located)
@onready var items_sort_node = $Items_sort
@onready var rubbish_sort = $"."

@onready var rubbish_pile_tile_inst = get_parent().get_parent().get_node("Environment/Rubbish/RubbishPileTile")

@onready var metal_bar_sprite = $Bins/Metal/MetalFilledBar
@onready var wood_bar_sprite = $Bins/Wood/WoodFilledBar
@onready var plastic_bar_sprite = $Bins/Plastic/PlasticFilledBar

var bin_bar_list = [preload("res://assets/bits and bobs/objective tools/Bar images/empty_bar.png"), 
	preload("res://assets/bits and bobs/objective tools/Bar images/bar 1:10.png"),
	preload("res://assets/bits and bobs/objective tools/Bar images/bar 2:10.png"),
	preload("res://assets/bits and bobs/objective tools/Bar images/bar 3:10.png"),
	preload("res://assets/bits and bobs/objective tools/Bar images/bar 4:10.png"),
	preload("res://assets/bits and bobs/objective tools/Bar images/1:2 bar.png"),
	preload("res://assets/bits and bobs/objective tools/Bar images/bar 6:10.png"),
	preload("res://assets/bits and bobs/objective tools/Bar images/bar 7:10.png"),
	preload("res://assets/bits and bobs/objective tools/Bar images/bar 8:10.png"),
	preload("res://assets/bits and bobs/objective tools/Bar images/bar 9:10.png"),
	preload("res://assets/bits and bobs/objective tools/Bar images/full_bar.png"),]

func _ready() -> void:
	Globals.rubbishsort_instance = self #set the empty variable in globals to this scene, just to
	#be able to refenerce this scene in globals

func _process(delta: float) -> void:
	
	
	if Globals.items_in_metal > 10:
		rubbish_pile_tile_inst.spawn_objective_tools(2)
		Globals.items_in_metal = 1
		Globals.old_items_inside_metal = 1
		metal_bar_sprite.texture = bin_bar_list[1]
		
	if Globals.items_in_wood > 10:
		rubbish_pile_tile_inst.spawn_objective_tools(8)
		Globals.items_in_wood = 1
		Globals.old_items_inside_wood = 1
		wood_bar_sprite.texture = bin_bar_list[1]
		#spawn wood
		
	if Globals.items_in_plastic > 10:
		rubbish_pile_tile_inst.spawn_objective_tools(3)
		Globals.items_in_plastic = 1
		Globals.old_items_inside_plastic = 1
		plastic_bar_sprite.texture = bin_bar_list[1]
		#spawn plastic
	
	if Globals.items_in_metal > Globals.old_items_inside_metal:
		Globals.old_items_inside_metal += 1
		update_metal_bar()
		
	if Globals.items_in_wood > Globals.old_items_inside_wood:
		Globals.old_items_inside_wood += 1
		update_wood_bar()
	
	if Globals.items_in_plastic > Globals.old_items_inside_plastic:
		Globals.old_items_inside_plastic += 1
		update_plastic_bar()
		
			
func _on_metal_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("items"): #if the object is an item
		Globals.is_inside_metal = true #cused in inv_item, used to check if is in area
	
func _on_metal_area_area_exited(area: Area2D) -> void: #-//-
	if area.is_in_group("items"):
		Globals.is_inside_metal = false

func _on_wood_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("items"):
		Globals.is_inside_wood = true

func _on_wood_area_area_exited(area: Area2D) -> void:
	if area.is_in_group("items"):
		Globals.is_inside_wood = false

func _on_plastic_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("items"):
		Globals.is_inside_plastic = true

func _on_plastic_area_area_exited(area: Area2D) -> void:
	if area.is_in_group("items"):
		Globals.is_inside_plastic = false

func update_metal_bar():
	Globals.items_in_metal = clamp(Globals.items_in_metal, 0, bin_bar_list.size() - 1)
	metal_bar_sprite.texture = bin_bar_list[Globals.items_in_metal]

func update_wood_bar():
	Globals.items_in_wood = clamp(Globals.items_in_wood, 0, bin_bar_list.size() - 1)
	wood_bar_sprite.texture = bin_bar_list[Globals.items_in_wood]
	
func update_plastic_bar():
	Globals.items_in_plastic = clamp(Globals.items_in_plastic, 0, bin_bar_list.size() - 1)
	plastic_bar_sprite.texture = bin_bar_list[Globals.items_in_plastic]
