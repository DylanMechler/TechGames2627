extends Area2D

signal PlayerMeleeAttack(enemies, damage)
signal player_position(position)
signal shoot_blaster(bullet, direction, location, damage)
signal player_death

var Bullet = preload("res://bullet.tscn")

@export var speed = 400
@export var max_health: float = 100
@export var health: float = 100
@export var heavy_melee_damage = 20
@export var light_melee_damage = 10
@export var heavy_ranged_damage = 15
@export var light_ranged_damage = 5
@export var meleeAttackSpeed = 0.75
@export var rangedAttackSpeed = 1.00
@export var reloadSpeed = 1.50
var horizontal_flip = 1 # Sets to -1 if player is facing left
var damage = 10
var mode_melee = true
var switch_weapon_state = true
var reloading = false
var max_weapon_ammo_count = 6
var weapon_ammo_count = 6
var meleeAttackReady = true
var rangedAttackReady = true
var enemy_in_range = false
var in_range_enemies = []
var health_bar_length = 440
var screen_size # Size of the game window

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$HUD/HealthBar/CurrentHealth.size.x = health_bar_length * (health / max_health)
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
		if horizontal_flip == -1:
			$AttackArea.position.x += 192
		horizontal_flip = 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
		if horizontal_flip == 1:
			$AttackArea.position.x -= 192
		horizontal_flip = -1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("switch_weapon"):
		if switch_weapon_state == true:
			mode_melee = !mode_melee
			switch_weapon_state = false
	if !Input.is_action_pressed("switch_weapon"):
		if switch_weapon_state == false:
			switch_weapon_state = true
	
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

#-------------------------------------------------------------------------------------- MELEE ATTACK
	if mode_melee == true:
		if meleeAttackReady:
			if Input.is_action_pressed("light_attack"): #LIGHT MELEE ATTACK
				damage = light_melee_damage
				print("Light Melee Attack")
				if enemy_in_range:
					PlayerMeleeAttack.emit(in_range_enemies, damage)
				meleeAttackReady = false
				$MeleeAttackTimer.start(meleeAttackSpeed)
#-------------------------------------------------------------------------------
			if Input.is_action_pressed("heavy_attack"): # HEAVY MELEE ATTACK
				damage = heavy_melee_damage
				print("Heavy Melee Attack")
				if enemy_in_range:
					PlayerMeleeAttack.emit(in_range_enemies, damage)
				meleeAttackReady = false
				$MeleeAttackTimer.start(meleeAttackSpeed)
#------------------------------------------------------------------------------------- RANGED ATTACK
	else:
			if Input.is_action_pressed("light_attack"): #LIGHT RANGED ATTACK
				if weapon_ammo_count <= 0:
					if !reloading:
						$ReloadTimer.start(reloadSpeed)
						print("Reloading...")
						reloading = true
				if rangedAttackReady:
					if !reloading:
						damage = light_ranged_damage
						print("Light Ranged Attack")
						shoot_blaster.emit(Bullet, horizontal_flip, position, damage)
						weapon_ammo_count -= 1
						$HUD/AmmoCount.text = "Ammo: " + str(weapon_ammo_count) + "/" + str(max_weapon_ammo_count)
						print(weapon_ammo_count)
						rangedAttackReady = false
						$RangedAttackTimer.start(rangedAttackSpeed)
#-------------------------------------------------------------------------------
			if Input.is_action_pressed("heavy_attack"): #HEAVY RANGED ATTACK
				if weapon_ammo_count <= 0:
					if !reloading:
						$ReloadTimer.start(reloadSpeed)
						print("Reloading...")
					reloading = true
				if rangedAttackReady:
					if !reloading:
						damage = heavy_ranged_damage
						print("Heavy Ranged Attack")
						shoot_blaster.emit(Bullet, horizontal_flip, position, damage)
						weapon_ammo_count -= 1
						$HUD/AmmoCount.text = "Ammo: " + str(weapon_ammo_count) + "/" + str(max_weapon_ammo_count)
						print(weapon_ammo_count)
						rangedAttackReady = false
						$RangedAttackTimer.start(rangedAttackSpeed)
	
	if health <= 0:
		player_death.emit()


func _on_melee_attack_timer_timeout():
	meleeAttackReady = true


func _on_ranged_attack_timer_timeout():
	rangedAttackReady = true


func _on_attack_area_area_entered(area):
	enemy_in_range = true
	in_range_enemies.append(area)


func _on_attack_area_area_exited(area):
	enemy_in_range = false
	in_range_enemies.erase(area)


func _on_game_scene_player_attacked(attack_damage):
	health -= attack_damage
	print("Health: ", health)


func _on_reload_timer_timeout():
	reloading = false
	weapon_ammo_count = max_weapon_ammo_count
	$HUD/AmmoCount.text = "Ammo: " + str(weapon_ammo_count) + "/" + str(max_weapon_ammo_count)
	print("Weapon Reloaded")
