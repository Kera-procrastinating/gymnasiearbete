extends Node2D

@export var austro : Astro
@export var tilemaplayer : TileMapLayer

@onready var pauseui = $CanvasLayer/PauseUI #pause scene in level scene
@onready var rubbishsorting = $CanvasLayer/RubbishSort #rubbish short scene in level scene

func _process(delta: float) -> void:
	if Input.is_action_pressed("pause"): #p button
		pauseui.visible = !pauseui.visible
		get_tree().paused = true #pauses absolutely everything, the whole game
	
	if Input.is_action_just_pressed("sorting"): #l button
		rubbishsorting.visible = !rubbishsorting.visible 
		Globals.rubbish_sort_visible = !Globals.rubbish_sort_visible #variable to be able to drop items, in the global code
	
func _ready() -> void:
	var inst = Globals.rubbish_sort_scene.instantiate()
	Globals.rubbishsort_instance = inst #takes instatiates scene back to globals
