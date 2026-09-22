extends Area2D

signal ranged_attack(bullet, direction, location, damage)

var Bullet = preload("res://enemy_bullet.tscn")

@onready var roam_timer: Timer = $RoamTimer
@onready var attack_timer: Timer = $AttackTimer
var screen_size
var movement_direction: Vector2 = Vector2.ZERO
var player_position: Vector2 = Vector2.ZERO
var player_detect = false
var player_attackable = false
var enemy_direction = 1 # 1 if player is to the right of the enemy, -1 if the player is to the left of the enemy
@export var speed = 150
@export var damage = 3
@export var health = 30

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	randomize()
	roam_timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	if player_detect:
		if position.y < player_position.y:
			velocity.y += 1
		elif position.y > player_position.y:
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
	
	velocity = velocity.normalized() * speed
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
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



func _on_roam_timer_timeout():
	if !player_detect:
		choose_new_direction()
	roam_timer.wait_time = randf_range(1.5, 4.0)


func _on_detection_area_area_entered(_area):
	player_detect = true


func _on_attack_timer_timeout():
		ranged_attack.emit(Bullet, enemy_direction, position, damage)


func _on_detection_area_area_exited(_area):
	player_detect = false


func _on_attack_area_area_entered(_area):
	player_attackable = true


func _on_attack_area_area_exited(_area):
	player_attackable = false
