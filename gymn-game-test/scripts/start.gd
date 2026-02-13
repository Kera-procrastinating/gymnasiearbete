extends Node2D

@onready var startui = $"."

func _on_play_button_pressed() -> void:
	startui.visible = false #start the game with a start ui
