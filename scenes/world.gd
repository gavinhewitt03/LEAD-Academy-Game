extends Node2D

func _ready():
	if global.first_load:
		$player.position.x = global.player_start_pos_x
		$player.position.y = global.player_start_pos_y
	else:
		$player.position.x = global.player_exit_cliffside_pos_x
		$player.position.y = global.player_exit_cliffside_pos_y

func _process(delta):
	change_scene()

func _on_cliff_side_area_body_entered(body):
	if "player" in body.name:
		global.transitioning_scenes = true

# essentially does nothing, just a safety net
func _on_cliff_side_area_body_exited(body):
	if "player" in body.name:
		global.transitioning_scenes = false

func change_scene():
	if global.transitioning_scenes:
		if global.current_scene == "world":
			get_tree().change_scene_to_file(("res://scenes/cliff_side.tscn"))
			global.first_load = false
			global.execute_change_scene()
