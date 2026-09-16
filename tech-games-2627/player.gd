extends Area2D

signal PlayerMeleeAttack(enemies, damage)
signal player_position(position)
signal player_death

@export var speed = 400
@export var health = 100
@export var heavy_damage = 20
@export var light_damage = 10
@export var meleeAttackSpeed = 0.75
var horizontal_flip = false # Sets to true if player is facing left
var damage = 10
var attackReady = true
var enemy_in_range = false
var in_range_enemies = []
var screen_size # Size of the game window

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
		if horizontal_flip:
			$AttackArea.position.x += 192
		horizontal_flip = false
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
		if !horizontal_flip:
			$AttackArea.position.x -= 192
		horizontal_flip = true
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$PlayerAnimatedSprite.play()
	else:
		$PlayerAnimatedSprite.stop()
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	player_position.emit(position)
	
	if velocity.x != 0:
		$PlayerAnimatedSprite.animation = "walk"
		$PlayerAnimatedSprite.flip_h = velocity.x < 0
	
	if attackReady:
		if Input.is_action_pressed("light_attack"):
			damage = light_damage
			print("Light Attack")
			if enemy_in_range:
				PlayerMeleeAttack.emit(in_range_enemies, damage)
			attackReady = false
			$MeleeAttackTimer.start(meleeAttackSpeed)
	if attackReady:
		if Input.is_action_pressed("heavy_attack"):
			damage = heavy_damage
			print("Heavy Attack")
			if enemy_in_range:
				PlayerMeleeAttack.emit(in_range_enemies, damage)
			attackReady = false
			$MeleeAttackTimer.start(meleeAttackSpeed)
	
	if health <= 0:
		player_death.emit()


func _on_melee_attack_timer_timeout():
	attackReady = true


func _on_attack_area_area_entered(area):
	enemy_in_range = true
	in_range_enemies.append(area)


func _on_attack_area_area_exited(area):
	enemy_in_range = false
	in_range_enemies.erase(area)


func _on_game_scene_player_attacked(attack_damage):
	health -= attack_damage
	print("Health: ", health)
