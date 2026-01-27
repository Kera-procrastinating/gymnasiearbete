extends TileMapLayer

const DIGGING_RANGE := 15
const DIG_TIME := 0.75

var dig_progress := 0.0
var digging := false



func _physics_process(delta: float) -> void:
	
	if (Globals.player_global_position.distance_to(get_global_mouse_position())< DIGGING_RANGE):
		
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			dig_progress += delta
			
			if dig_progress >= DIG_TIME:
				finish_dig()
				
		else:
			cancel_dig()

func finish_dig():
	digging = false
	var tile= local_to_map(get_global_mouse_position())
	set_cell(tile, 0, Vector2i(-1,-1))#remove the tile
	dig_progress = 0.0

		
func cancel_dig():
	digging = false
	dig_progress = 0.0

	
		
		
		
		
		
		
		
		
		
