extends Area2D

signal ranged_attack(bullet, direction, location, damage)
signal player_hit(damage)
signal knockback_player(direction)

var Bullet = preload("res://Entities/Enemies/tscn/enemy_bullet.tscn")

@onready var roam_timer: Timer = $RoamTimer
@onready var attack_timer: Timer = $AttackTimer
@onready var special_attack_timer: Timer = $SpecialAttackTimer
@onready var attack_build_up_timer: Timer = $AtttackBuildUpTimer
var level_size
var movement_direction: Vector2 = Vector2.ZERO
var player_position: Vector2 = Vector2.ZERO
var player_detect = false
var player_attackable = false
var attack_started = false
var attack_type = "normal" # normal, beam, and explosive
var collidables = []
var tile_size = 128
var player_tile_size = 64
var player_in_beam_area = false
var enemy_direction = 1 # 1 if player is to the right of the enemy, -1 if the player is to the left of the enemy
var special_attack_ready = true
@export var speed = 175
@export var damage = 6
@export var health = 50.0
@export var max_health = 50.0

# Called when the node enters the scene tree for the first time.
func _ready():
	level_size = get_viewport_rect().size * 2
	randomize()
	roam_timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	if player_detect:
		if position.y < player_position.y - 2:
			velocity.y += 1
		elif position.y > player_position.y + 2:
			velocity.y -= 1
		if !player_attackable:
			if position.x < player_position.x:
				velocity.x += 1
			elif position.x > player_position.x:
				velocity.x -= 1
		if player_position.x < position.x:
			enemy_direction = -1
		else:
			enemy_direction = 1
	else:
		velocity = movement_direction * speed
		if velocity.x < 0:
			enemy_direction = -1
		else:
			enemy_direction = 1
	
	for collidable in collidables:
		var check_position = position + (velocity * delta)
		if ((check_position.x - (tile_size/2.0)) < (collidable.position.x + (collidable.tile_size/2.0))) && ((check_position.x + (tile_size/2.0)) > (collidable.position.x - (collidable.tile_size/2.0))):
			if (((check_position.y - (tile_size/2.0)) >= (collidable.position.y - (tile_size/2.0))) && ((check_position.y - (tile_size/2.0)) <= (collidable.position.y + (tile_size/2.0)))) || (((check_position.y + (tile_size/2.0)) <= (collidable.position.y + (tile_size/2.0))) && ((check_position.y + (tile_size/2.0)) >= (collidable.position.y - (tile_size/2.0)))):
				velocity.x = 0
	
	
	velocity = velocity.normalized() * speed
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, level_size)
	
	beam_attack_check()
	
	knockback_check()
	
	if enemy_direction == 1:
		$Sprite2D.flip_h = false
	elif enemy_direction == -1:
		$Sprite2D.flip_h = true
	
	if player_attackable && ((position.y >= player_position.y - 100) && (position.y <= player_position.y + 100)):
		if attack_timer.is_stopped():
			attack_timer.start()
	else:
		if !attack_timer.is_stopped():
			attack_timer.stop()
	
	if health <= 0:
		queue_free()


func choose_new_direction():
	var random_x = randf_range(-1.0, 1.0)
	var random_y = randf_range(-1.0, 1.0)
	movement_direction = Vector2(random_x, random_y).normalized()


func choose_attack_type():
	if special_attack_ready:
		var rand_attack = randi_range(1, 2) # 1:Beam, 2:Explosive
		if (rand_attack == 1) && player_in_beam_area:
			print("BEAM ATTACK CHARGING")
			attack_type = "beam"
			attack_started = true
			special_attack_ready = false
			attack_build_up_timer.start()
		elif rand_attack == 2:
			print("EXPLOSIVE ATTACK CHARGING")
			attack_type = "explosive"
			attack_started = true
			special_attack_ready = false
			attack_build_up_timer.start()
		else:
			attack_started = false
	else:
		attack_type = "normal"
		print("Normal Attack")
		ranged_attack.emit(Bullet, enemy_direction, position, damage)


func knockback_check():
	if enemy_direction == -1:
		if (position.x - player_position.x) <= ((tile_size/6.0) + tile_size):
			print("KNOCKBACK EMITTED")
			knockback_player.emit(enemy_direction)
	elif enemy_direction == 1:
		if (player_position.x - position.x) <= ((tile_size/6.0) + tile_size):
			print("KNOCKBACK EMITTED")
			knockback_player.emit(enemy_direction)


func beam_attack_check():
	if player_position.x > (position.x * enemy_direction):
		if ((player_position.y - player_tile_size) >= (position.y - tile_size/4.0)) || ((player_position.y + player_tile_size) <= (position.y + tile_size/4.0)):
			player_in_beam_area = true


func _on_roam_timer_timeout():
	if !player_detect:
		choose_new_direction()
	roam_timer.wait_time = randf_range(1.5, 4.0)


func _on_detection_area_area_entered(_area):
	player_detect = true


func _on_attack_timer_timeout():
	choose_attack_type()


func _on_detection_area_area_exited(_area):
	player_detect = false


func _on_attack_area_area_entered(_area):
	player_attackable = true


func _on_attack_area_area_exited(_area):
	player_attackable = false


func _on_special_attack_timer_timeout():
	special_attack_ready = true


func _on_atttack_build_up_timer_timeout():
	if attack_type == "beam":
		print("Mini-Boss Beam")
		beam_attack_check()
		if player_in_beam_area:
			player_hit.emit(damage * 2)
		attack_timer.start()
		special_attack_timer.start()
		attack_started = false
	elif attack_type == "explosive":
		print("Mini-Boss Explosive")
		attack_timer.start()
		special_attack_timer.start()
		attack_started = false
