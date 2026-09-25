extends Area2D
@onready var roam_timer: Timer = $RoamTimer
@onready var attack_timer: Timer = $AttackTimer
signal player_hit(damage)
var screen_size
var movement_direction: Vector2 = Vector2.ZERO
var player_position: Vector2 = Vector2.ZERO
var enemy_direction = 1
var player_detect = false
var attack_started = false
var collidables = []
@export var speed = 150
@export var damage = 5
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
		velocity = (player_position - position).normalized() * speed
	else:
		velocity = movement_direction * speed
	
	if velocity.x < 0:
		if enemy_direction == 1:
			$AttackArea.position.x -= 144
			enemy_direction = -1
	elif velocity.x > 0:
		if enemy_direction == -1:
			$AttackArea.position.x += 144
			enemy_direction = 1
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	for collidable in collidables:
		if collidable.get_shape().get_rect().intersects($CollisionShape2D.get_shape().get_rect()):
			print("INTERSECTS")
			var intersection_rect = collidable.get_shape().get_rect().intersection($CollisionShape2D.get_shape().get_rect())
			if collidable.position.x > position.x:
				position.x -= intersection_rect.size.x
			else:
				position.x += intersection_rect.size.x
			if collidable.position.y > position.y:
				position.y -= intersection_rect.size.y
			else:
				position.y += intersection_rect.size.y
	
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
		player_hit.emit(damage)


func _on_detection_area_area_exited(_area):
	player_detect = false


func _on_attack_area_area_entered(_area):
	if !attack_started:
		attack_timer.start()
		attack_started = true

func _on_attack_area_area_exited(_area):
	if attack_started:
		attack_timer.stop()
		attack_started = false
