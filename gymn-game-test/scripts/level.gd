extends Node2D

@export var austro : Astro
@export var tilemaplayer : TileMapLayer

@onready var pauseui = $CanvasLayer/PauseUI
@onready var rubbishsorting = $CanvasLayer/RubbishSort

func _process(delta: float) -> void:
	if Input.is_action_pressed("pause"):
		pauseui.visible = !pauseui.visible
		get_tree().paused = true
	
	if Input.is_action_just_pressed("sorting"):
		rubbishsorting.visible = !rubbishsorting.visible
	
