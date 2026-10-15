extends Area2D
@onready var roam_timer: Timer = $RoamTimer
@onready var attack_timer: Timer = $AttackTimer
@onready var special_attack_timer: Timer = $SpecialAttackTimer
@onready var attack_build_up_timer: Timer = $AttackBuildUpTimer
signal player_hit(damage)
var level_size
var movement_direction: Vector2 = Vector2.ZERO
var player_position: Vector2 = Vector2.ZERO
var enemy_direction = 1
var player_detect = false
var attack_started = false
var collidables = []
var tile_size = 128
var player_tile_size = 64
var attack_type = "normal" # Sets the type of attack that will be used in the next attack. normal, slam, or charge
var special_attack_ready = true
var special_attack_multiplier = 2
var player_in_normal_area = false
var player_in_slam_area = false
var player_in_charge_area = false
var charge_hit_player = false
var collision_type = "normal" # normal collision is the typical collision, charge collision is the collision for the charge attack
var charge_distance
var charge_starting_position # Only uses X value
var charge_speed = 500
@export var speed = 125
@export var damage = 10
@export var health = 60.0
@export var max_health = 60.0

 
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
		if collision_type == "normal":
			velocity = (player_position - position).normalized() * speed
		elif collision_type == "charge" && ((position.x != (charge_starting_position - (charge_distance * enemy_direction))) && ((position.x != 0) && (position.x != level_size.x))):
			velocity.x += (1 * charge_speed) * enemy_direction
		elif collision_type == "charge" && ((position.x == (charge_starting_position - (charge_distance * enemy_direction))) || ((position.x == 0) || (position.x == level_size.x))):
			collision_type = "normal"
			attack_timer.start()
			special_attack_timer.start()
			attack_started = false
			charge_hit_player = false
	else:
		velocity = movement_direction * speed
	
	if collision_type == "normal":
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
		if collision_type == "normal":
			if ((check_position.x - (tile_size/2.0)) < (collidable.position.x + (collidable.tile_size/2.0))) && ((check_position.x + (tile_size/2.0)) > (collidable.position.x - (collidable.tile_size/2.0))):
				if (((check_position.y - (tile_size/2.0)) >= (collidable.position.y - (tile_size/2.0))) && ((check_position.y - (tile_size/2.0)) <= (collidable.position.y + (tile_size/2.0)))) || (((check_position.y + (tile_size/2.0)) <= (collidable.position.y + (tile_size/2.0))) && ((check_position.y + (tile_size/2.0)) >= (collidable.position.y - (tile_size/2.0)))):
					velocity.x = 0
			
			
			if ((check_position.y - (tile_size/2.0)) < (collidable.position.y + (collidable.tile_size/2.0))) && ((check_position.y + (tile_size/2.0)) > (collidable.position.y - (collidable.tile_size/2.0))):
				if (((check_position.x - (tile_size/2.0)) >= (collidable.position.x - (tile_size/2.0))) && ((check_position.x - (tile_size/2.0)) <= (collidable.position.x + (tile_size/2.0)))) || (((check_position.x + (tile_size/2.0)) <= (collidable.position.x + (tile_size/2.0))) && ((check_position.x + (tile_size/2.0)) >= (collidable.position.x - (tile_size/2.0)))):
					velocity.y = 0
	
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, level_size)
	
	
	if collision_type == "charge":
		if ((player_position.x + (player_tile_size/2.0)) > (position.x - (tile_size/2.0))) && ((player_position.x - (player_tile_size/2.0)) < (position.x + (tile_size/2.0))):
			if ((player_position.y + (player_tile_size/2.0)) > (position.y - (tile_size/2.0))) && ((player_position.y - (player_tile_size/2.0)) < (position.y + (tile_size/2.0))):
				if !charge_hit_player:
					print("Mini-Boss Charge")
					player_hit.emit(damage * special_attack_multiplier)
					charge_hit_player = true
	
	
	if ((position.y + (tile_size/2.0) > player_position.y) && (position.y - (tile_size/2.0) < player_position.y)) && player_detect:
		if !player_in_charge_area:
			player_in_charge_area = true
	else:
		if player_in_charge_area:
			player_in_charge_area = false
	
	
	if (player_in_normal_area || player_in_slam_area || player_in_charge_area) && !attack_started:
		attack_timer.start()
		attack_started = true
	
	
	if health <= 0:
		queue_free()


func choose_new_direction():
	var random_x = randf_range(-1.0, 1.0)
	var random_y = randf_range(-1.0, 1.0)
	movement_direction = Vector2(random_x, random_y).normalized()


func choose_attack_type():
	if special_attack_ready:
		var rand_attack = randi_range(1, 2) # 1:Slam, 2:Charge
		if (rand_attack == 1) && (player_in_slam_area):
			attack_type = "slam"
			special_attack_ready = false
			attack_build_up_timer.start()
		elif (rand_attack == 2) && (player_in_charge_area):
			attack_type = "charge"
			charge_starting_position = position.x
			special_attack_ready = false
			attack_build_up_timer.start()
		else:
			attack_started = false
	elif player_in_normal_area:
		attack_type = "normal"
		print("Mini-Boss Normal")
		player_hit.emit(damage)
		attack_started = false


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
	player_in_normal_area = true
	print("Mini-Boss Normal Area Entered")

func _on_attack_area_area_exited(_area):
	player_in_normal_area = false
	print("Mini-Boss Normal Area Exited")


func _on_special_attack_timer_timeout():
	special_attack_ready = true


func _on_attack_build_up_timer_timeout():
	if attack_type == "slam":
		print("Mini-Boss Slam")
		player_hit.emit(damage * special_attack_multiplier)
		attack_timer.start()
		special_attack_timer.start()
		attack_started = false
	elif attack_type == "charge":
		collision_type = "charge"


func _on_slam_damage_area_area_entered(_area):
	player_in_slam_area = true
	print("Mini-Boss Slam Area Entered")


func _on_slam_damage_area_area_exited(_area):
	player_in_slam_area = false
	print("Mini-Boss Slam Area Exited")
