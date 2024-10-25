extends Node

var player_current_attack = false

var current_scene = "world" # world or cliff_side
var transitioning_scenes = false

var player_exit_cliffside_pos_x = 197
var player_exit_cliffside_pos_y = 29
var player_start_pos_x = 155
var player_start_pos_y = 108

var first_load = true

func execute_change_scene():
	transitioning_scenes = false
	if current_scene == "world":
		print("changing scene to cliff side")
		current_scene = "cliff_side"
	else:
		current_scene = "world"
