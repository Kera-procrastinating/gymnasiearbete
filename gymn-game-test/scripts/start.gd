extends Node2D

@onready var startui = $"."

func _on_play_button_pressed() -> void:
	startui.visible = false
