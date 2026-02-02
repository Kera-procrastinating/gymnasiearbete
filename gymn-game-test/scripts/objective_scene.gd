extends Node2D

@onready var label = $Panel/Objective

var objective = 1

func _process(delta: float) -> void:
	if objective == 1:
		label.text = "Objective: Collectct 10 items"
		objects_collected()
	elif objective == 2:
		label.text = ""
		await get_tree().create_timer(2.0).timeout

	
func objects_collected():
	if Globals.invno > 10:
		label.text = "Objective complete"
		await get_tree().create_timer(5.0).timeout
		objective = 2
