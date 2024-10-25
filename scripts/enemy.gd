extends CharacterBody2D

var speed = 60
var player_chase = false
var player = null

var health = 100
var player_in_attack_range = false
var receive_damage = true

func _physics_process(delta):
	deal_with_damage()
	update_health()
	
	if player_chase:
		position += (player.position - position)/speed
		move_and_slide()
		
		$AnimatedSprite2D.play("walk")
		
		if (player.position.x - position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	elif health > 0:
		$AnimatedSprite2D.play("idle")

func _on_detection_area_body_entered(body):
	player = body
	player_chase = true

func _on_detection_area_body_exited(body):
	player = null
	player_chase = false

func _on_enemy_hitbox_body_entered(body):
	if "player" in body.name:
		player_in_attack_range = true


func _on_enemy_hitbox_body_exited(body):
	if "player" in body.name:
		player_in_attack_range = false

func deal_with_damage():
	if player_in_attack_range and global.player_current_attack:
		if receive_damage:
			health -= 30
			$damage_cooldown.start()
			receive_damage = false
			death()
			
func _on_damage_cooldown_timeout() -> void:
	receive_damage = true

func update_health():
	$healthbar.value = health
	
	if health >= 100:
		$healthbar.visible = false
	else:
		$healthbar.visible = true

func death():
	if health <= 0:
		player_chase = false
		player_in_attack_range = false
		$AnimatedSprite2D.play("death")
		$AnimatedSprite2D.connect("animation_finished", func(): queue_free(), CONNECT_ONE_SHOT)
