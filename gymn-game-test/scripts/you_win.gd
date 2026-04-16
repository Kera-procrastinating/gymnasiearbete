extends Control

@onready var you_win_scene = $"."
@onready var bgmusic = get_parent().get_node("MusicUI/BgMusic")
@onready var won_music = get_parent().get_parent().get_node("MusicAndEffects/WonMusic")
@onready var inventory_ui = get_parent().get_node("InventoryGUI")

func _on_quit_button_pressed() -> void:
	get_tree().quit() #close the whole game

func _on_continue_button_pressed() -> void:
	#reset char pos
	you_win_scene.visible = false
	get_tree().paused = false 
	bgmusic.play()
	won_music.stop()


func _on_new_game_button_pressed() -> void:
	get_tree().paused = false
	
	inventory_ui.clear_inventory()
	
	Globals.trees_fully_grown = 0
	Globals.no_tiles = false

	Globals.dig_time = 2

	Globals.objectives_completed = 0 
	Globals.invno = 0 
	Globals.objective = 1
	Globals.objective_1_complete = false 
	
	
	get_tree().reload_current_scene()
