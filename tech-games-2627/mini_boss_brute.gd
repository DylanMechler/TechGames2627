extends Area2D
@onready var roam_timer: Timer = $RoamTimer
@onready var attack_timer: Timer = $AttackTimer
signal player_hit(damage)
var level_size
var movement_direction: Vector2 = Vector2.ZERO
var player_position: Vector2 = Vector2.ZERO
var enemy_direction = 1
var player_detect = false
var attack_started = false
var attackable_area = "none" # none - player not attackable, slam - player in the slam damage area, normal - player in the normal attack area
var collision_state = "normal" # normal collision is the same as basic enemy collision, charge collision is the collision used when the mini-boss is charging
var collidables = []
var tile_size = 128
var charge_distance
@export var speed = 125
@export var charge_attack_speed = 175
@export var damage = 10
@export var health = 60

 
# Called when the node enters the scene tree for the first time.
func _ready():
	level_size = get_viewport_rect().size * 2
	charge_distance = get_viewport_rect().size.x
	randomize()
	roam_timer.start()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	if player_detect:
		if collision_state != "charge":
			velocity = (player_position - position).normalized() * speed
		elif collision_state == "charge":
			velocity = (((position + (charge_distance * enemy_direction)) - position)).normalized() * charge_attack_speed
	else:
		velocity = movement_direction * speed
	
	if velocity.x < 0:
		if enemy_direction == 1:
			$AttackArea.position.x -= 160
			enemy_direction = -1
	elif velocity.x > 0:
		if enemy_direction == -1:
			$AttackArea.position.x += 160
			enemy_direction = 1
	
	
	for collidable in collidables:
		var check_position = position + (velocity * delta)
		if ((check_position.x - (tile_size/2.0)) < (collidable.position.x + (collidable.tile_size/2.0))) && ((check_position.x + (tile_size/2.0)) > (collidable.position.x - (collidable.tile_size/2.0))):
			if (((check_position.y - (tile_size/2.0)) >= (collidable.position.y - (tile_size/2.0))) && ((check_position.y - (tile_size/2.0)) <= (collidable.position.y + (tile_size/2.0)))) || (((check_position.y + (tile_size/2.0)) <= (collidable.position.y + (tile_size/2.0))) && ((check_position.y + (tile_size/2.0)) >= (collidable.position.y - (tile_size/2.0)))):
				velocity.x = 0
		
		
		if ((check_position.y - (tile_size/2.0)) < (collidable.position.y + (collidable.tile_size/2.0))) && ((check_position.y + (tile_size/2.0)) > (collidable.position.y - (collidable.tile_size/2.0))):
			if (((check_position.x - (tile_size/2.0)) >= (collidable.position.x - (tile_size/2.0))) && ((check_position.x - (tile_size/2.0)) <= (collidable.position.x + (tile_size/2.0)))) || (((check_position.x + (tile_size/2.0)) <= (collidable.position.x + (tile_size/2.0))) && ((check_position.x + (tile_size/2.0)) >= (collidable.position.x - (tile_size/2.0)))):
				velocity.y = 0
	
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, level_size)
	
	
	if health <= 0:
		queue_free()


func choose_new_direction():
	var random_x = randf_range(-1.0, 1.0)
	var random_y = randf_range(-1.0, 1.0)
	movement_direction = Vector2(random_x, random_y).normalized()


func choose_attack_type():
		var attack_type = randi_range(1, 4) # 1:Slam, 2:Charge, 3:Normal
		if attack_type == 1:
			print("Slam Attack")
		elif attack_type == 2:
			print("Charge Attack")
		elif attack_type == 3:
			print("Normal Attack")
			player_hit.emit(damage)


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
	if !attack_started:
		attack_timer.start()
		attack_started = true

func _on_attack_area_area_exited(_area):
	if attack_started:
		attack_timer.stop()
		attack_started = false
