extends Control

@onready var you_win_scene = $"."
@onready var bgmusic = get_parent().get_node("MusicUI/BgMusic")
@onready var won_music = get_parent().get_parent().get_node("MusicAndEffects/WonMusic")

func _on_quit_button_pressed() -> void:
	get_tree().quit() #close the whole game


func _on_continue_button_pressed() -> void:
	#reset char pos
	you_win_scene.visible = false
	get_tree().paused = false 
	bgmusic.play()
	won_music.stop()


func _on_new_game_button_pressed() -> void:
	pass
