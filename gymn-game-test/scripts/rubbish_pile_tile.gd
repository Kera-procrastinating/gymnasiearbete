extends TileMapLayer

const DIGGING_RANGE = 15

func _physics_process(delta: float) -> void:
	if (Input.is_action_just_pressed("interact")): #if E is pressed
		if Globals.player_global_position.distance_to(get_global_mouse_position())< DIGGING_RANGE:
			var tile= local_to_map(get_global_mouse_position()) #the tile is the positionof the mouse
			set_cell(tile, 0, Vector2i(-1,-1))#remove the tile
			
			
			#drop randomised items
	
