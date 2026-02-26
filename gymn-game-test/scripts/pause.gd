extends Node2D

@onready var pauseui = $"."

func _on_unpause_button_pressed() -> void:
	pauseui.visible = false
	$"../../MusicAndEffects/PauseSound".play()
	get_tree().paused = false ##############
	
func _on_quit_button_pressed() -> void:
	get_tree().quit() #close the whole game
