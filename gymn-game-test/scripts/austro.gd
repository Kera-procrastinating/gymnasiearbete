extends CharacterBody2D #uses velocity to use collision
class_name Astro

@onready var anim: AnimatedSprite2D = $IdleAnimatedSprite2D
@onready var interact_ui = $InteractUI
@onready var inventory_ui = get_parent().get_node("CanvasLayer/InventoryGUI")
@onready var inventory_ui_closed = get_parent().get_node("CanvasLayer/InventoryClosed")
@onready var objective_scene = get_parent().get_node("CanvasLayer/ObjectiveScene")
@onready var footsteps := $FootstepsGrass
@onready var inventory_hotbar = $InventoryHotbar/InventoryHotbar
@onready var level = get_parent()
@onready var rubbish_pile_tile = get_parent().get_node("Environment/Rubbish/RubbishPileTile")

@export var speed := 55 
enum{IDLE, WALK}

const DIGGING_RANGE= 18

var state = IDLE
var direction = Input.get_vector("left", "right", "up", "down")
var last_moving_dir = Vector2.ZERO
var is_digging : bool


func _ready() -> void:
	Globals.set_player_reference(self) #in globals

	position = Vector2(343,288) # start pos
	anim.play("idle_down") #start animation

func _physics_process( delta: float) -> void:
	
	Globals.player_global_position = global_position #in globals player glob pos is vector 2D,###########
	
	var dir = Input.get_vector("left", "right", "up", "down")
	velocity = dir * speed
	
	if dir != Vector2.ZERO: #vector.zero faces nowhere when button isnt being pressed
		last_moving_dir = dir # essentially, if the inputed direction is not nothing, 
		_walk_state(dir)	#then face the inputed direction and walk...i dont get it..
	else:
		_idle_state()
		
	move_and_slide()
	
	if Input.is_action_just_pressed("pick_up"):
		var pickup_audio = $PickupAudio
		pickup_audio.play()

	
func _idle_state()-> void:
	if footsteps.playing:
		footsteps.stop()
	
	if last_moving_dir.x < 0:
		$IdleAnimatedSprite2D.flip_h = true
		anim.play("idle_right")
	elif last_moving_dir.x > 0:
		$IdleAnimatedSprite2D.flip_h = false
		anim.play("idle_right")
	elif last_moving_dir.y < 0:
		anim.play("idle_up")
	elif last_moving_dir.y > 0:
		anim.play("idle_down")

func _walk_state(direction: Vector2)-> void:
	if not footsteps.playing:
		footsteps.pitch_scale = randf_range(0.9, 1.15)
		footsteps.play()
	
	if direction.x < 0:
		$IdleAnimatedSprite2D.flip_h = true
		anim.play("walk_right")
	elif direction.x > 0:
		$IdleAnimatedSprite2D.flip_h = false
		anim.play("walk_right")
	elif direction.y < 0:
		anim.play("walk_up")
	elif direction.y > 0:
		anim.play("walk_down")

func _input(event):
	if event.is_action_pressed("toggle_inv"):
		inventory_ui.visible = !inventory_ui.visible #inventory ui seen is invisble if visible and vice versa
		inventory_ui_closed.visible = !inventory_ui_closed.visible

func apply_item_effect(item): #items with special effects can effect the character, taken to inverntory slot ui
	match item["effect"]:
		"speed": #applied to apple in spawnable_rubbish_items list in globals, adds to all apples
			speed += 30
			await get_tree().create_timer(6.0).timeout
			speed -= 30
			print("speed increased to ", speed)
		"plant":
			Globals.seeds_used = true #used in level scene to plant as a tile
		"water":
			Globals.grow_tree = true
			Globals.spawned_tree = true
			
		_:
			print("There is no effect for this item") #no effect does nothing, maybe add visible box later


##next two funcs: if item is in hotbar and has effect,clicking the hotbar keys, uses item

func use_hotbar_item(slot_index): #using hotbar shortcuts, button-1 to use up items
	if slot_index < Globals.hotbar_inventory.size():
		var item = Globals.hotbar_inventory[slot_index]
		if item != null:
			apply_item_effect(item) #use item effect from hotbar
			item["quantity"] -= 1
			if item["quantity"] <= 0:
				Globals.hotbar_inventory[slot_index] = null
				Globals.remove_items(item["type"], item["effect"], item["name"])
			Globals.inventory_updated.emit()
		
func _unhandled_input(event):
	if event is InputEventKey and event.pressed:
		for i in range(Globals.hotbar_size):
			if Input.is_action_just_pressed("hotbar_" + str(i+1)):
				use_hotbar_item(i)
				break
		
		
		
		
	
	
	
