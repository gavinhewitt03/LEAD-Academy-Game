extends Node2D

func _process(delta):
	change_scenes()

func _on_cliff_side_exit_body_entered(body):
	if "player" in body.name:
		global.transitioning_scenes = true

# also safety net
func _on_cliff_side_exit_body_exited(body):
	if "player" in body.name:
		global.transitioning_scenes = false

func change_scenes():
	if global.transitioning_scenes:
		if global.current_scene == "cliff_side":
			get_tree().change_scene_to_file("res://scenes/world.tscn")
			global.execute_change_scene()
