extends TileMapLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if (Input.is_action_just_pressed("breaking")):
		var tile= local_to_map(get_global_mouse_position())
		set_cell(tile, 0, Vector2i(-1,-1))
	
