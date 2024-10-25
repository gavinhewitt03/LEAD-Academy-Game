extends CharacterBody2D

var enemy_in_attack_range = false
var enemy_attack_cooldown = true
var health = 100
var player_alive = true

var attack_in_progress = false

const speed = 100
var current_dir = "none"

var ProcessMode

func _ready():
	$AnimatedSprite2D.play("front_idle")

func _physics_process(delta: float) -> void:
	player_movement(delta)
	enemy_attack()
	attack()
	update_health()
	death()
	
func player_movement(delta):
	if player_alive:
		if Input.is_action_pressed("ui_right"):
			current_dir = "right"
			play_anim(1)
			velocity.x = speed
			velocity.y = 0
		elif Input.is_action_pressed("ui_left"):
			current_dir = "left"
			play_anim(1)
			velocity.x = -speed
			velocity.y = 0
		elif Input.is_action_pressed("ui_down"):
			current_dir = "down"
			play_anim(1)
			velocity.x = 0
			velocity.y = speed
		elif Input.is_action_pressed("ui_up"):
			current_dir = "up"
			play_anim(1)
			velocity.x = 0
			velocity.y = -speed
		else:
			play_anim(0)
			velocity.x = 0
			velocity.y = 0
		
		move_and_slide()
	
func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	if dir == "right":
		anim.flip_h = false
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			if !attack_in_progress:
				anim.play("side_idle")
	if dir == "left":
		anim.flip_h = true
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			if !attack_in_progress:
				anim.play("side_idle")
	
	if dir == "down":
		if movement == 1:
			anim.play("front_walk")
		elif movement == 0:
			if !attack_in_progress:
				anim.play("front_idle")
	if dir == "up":
		if movement == 1:
			anim.play("back_walk")
		elif movement == 0:
			if !attack_in_progress:
				anim.play("back_idle")

func _on_player_hitbox_body_entered(body):
	if "enemy" in body.name:
		enemy_in_attack_range = true

func _on_player_hitbox_body_exited(body):
	if "enemy" in body.name:
		enemy_in_attack_range = false

func enemy_attack():
	if enemy_in_attack_range and enemy_attack_cooldown:
		health -= 10
		enemy_attack_cooldown = false
		$damage_cooldown.start()

func _on_damage_cooldown_timeout():
	enemy_attack_cooldown = true
	
func attack():
	var dir = current_dir
	
	if Input.is_action_just_pressed("attack"):
		global.player_current_attack = true
		attack_in_progress = true
		if dir == "right":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("side_attack")
			$attack_cooldown.start()
		elif dir == "left":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("side_attack")
			$attack_cooldown.start()
		elif dir == "down":
			$AnimatedSprite2D.play("front_attack")
			$attack_cooldown.start()
		elif dir == "up":
			$AnimatedSprite2D.play("back_attack")
			$attack_cooldown.start()

func _on_attack_cooldown_timeout():
	$attack_cooldown.stop()
	global.player_current_attack = false
	attack_in_progress = false

func current_camera():
	if global.current_scene == "world":
		$world_camera.enabled = true
		$cliffside_camera.enabled = false
	else:
		$world_camera.enabled = false
		$cliffside_camera.enabled = true

func update_health():
	$healthbar.value = health
	
	if health >= 100:
		$healthbar.visible = false
	else:
		$healthbar.visible = true

func _on_regen_timer_timeout():
	if !enemy_in_attack_range and player_alive:
		if health < 100 :
			health += 20
			if health > 100:
				health = 100

func _on_respawn_timer_timeout():
	$respawn_timer.stop()
	player_alive = true
	position.x = global.player_start_pos_x
	position.y = global.player_start_pos_y
	health = 50

func death():
	if health <= 0 and player_alive: 
		player_alive = false # player has died
		health = 0
		$AnimatedSprite2D.play("death")
		velocity.x = 0
		velocity.y = 0
		if $respawn_timer.is_stopped():
			$respawn_timer.start()
