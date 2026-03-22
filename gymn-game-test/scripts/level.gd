extends Node2D

@export var austro : Astro
@export var tilemaplayer : TileMapLayer

@onready var pauseui = $CanvasLayer/PauseUI #pause scene in level scene
@onready var rubbishsorting = $CanvasLayer/RubbishSort #rubbish short scene in level scene
@onready var Items = $Items
@onready var green_ground = $LargeFlatArea/LandWaterALive
@onready var green_ground_hills = $LargeFlatArea/LandLandAlive

func _process(delta: float) -> void:
	if Input.is_action_pressed("pause"): #p button
		pauseui.visible = !pauseui.visible
		get_tree().paused = true #pauses absolutely everything, the whole game
	
	if Input.is_action_just_pressed("sorting"): #l button
		rubbishsorting.visible = !rubbishsorting.visible 
		Globals.rubbish_sort_visible = !Globals.rubbish_sort_visible #variable to be able to drop items, in the global code
	
	update_ground()
	
func _ready() -> void:
	Globals.level_instance = self
	
	var instantiated_level = Globals.level_scene.instantiate()
	Globals.level_instance = instantiated_level
	
	var inst = Globals.rubbish_sort_scene.instantiate()
	Globals.rubbishsort_instance = inst #takes instatiates scene back to globals


func update_ground():
	if Globals.objectives_completed == 0:
		green_ground.modulate.a = 0
		green_ground_hills.modulate.a = 0
	elif Globals.objectives_completed == 1:
		green_ground.modulate.a = 0.2
		green_ground_hills.modulate.a = 0.2
	elif Globals.objectives_completed == 2:
		green_ground.modulate.a = 0.4
		green_ground_hills.modulate.a = 0.4
	elif Globals.objectives_completed == 3:
		green_ground.modulate.a = 0.6
		green_ground_hills.modulate.a = 0.6
