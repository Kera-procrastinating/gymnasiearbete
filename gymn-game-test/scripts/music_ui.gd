extends Node2D

@onready var music_button = $BgMusic
@onready var music_image = $MuteButtonImage

var music_playing = true

func _on_button_pressed() -> void:
	music_playing = !music_playing
	
	if music_playing:
		music_button.volume_db = -12
		music_image.texture = load("res://assets/inventory assets/music_playing.png")
	else:
		music_button.volume_db = -80
		music_image.texture = load("res://assets/inventory assets/music_mute.png")
	
	
