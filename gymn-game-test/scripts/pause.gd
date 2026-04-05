extends Node2D

@onready var pause_ui_node = $"."

func _on_unpause_button_pressed() -> void:
	pause_ui_node.visible = false
	$"../../MusicAndEffects/PauseSound".play()
	get_tree().paused = false 
	
func _on_quit_button_pressed() -> void:
	get_tree().quit() #close the whole game
