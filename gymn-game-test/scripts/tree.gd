extends Node2D

@onready var stage1 = $SmallestTree
@onready var stage2 = $SmallTree
@onready var stage3 = $MediumTree
@onready var stage4 = $BigTree
@onready var stage5 = $BigPlumTree

var stage := 1

func grow():
	stage += 1
	update_visual()
	Globals.grow_tree = false
	
func update_visual():
	stage1.visible = stage == 1
	stage2.visible = stage == 2
	stage3.visible = stage == 3
	stage4.visible = stage == 4
	stage5.visible = stage >= 5
	
	if stage >= 5:
		Globals.trees_fully_grown += 1


func _on_body_entered(body: Astro) -> void:
	Globals.player_in_tree_range = true

func _on_body_exited(body: Astro) -> void:
	Globals.player_in_tree_range = false
