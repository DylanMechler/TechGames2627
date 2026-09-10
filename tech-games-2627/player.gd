extends Area2D

signal PlayerLightMeleeAttack
signal PlayerHeavyMeleeAttack
signal player_position(position)

@export var speed = 200
@export var damage = 10
@export var health = 100
@export var meleeAttackSpeed = 0.75
var attackReady = true
var screen_size # Size of the game window

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
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
			PlayerLightMeleeAttack.emit()
			print("Light Attack")
			attackReady = false
			$MeleeAttackTimer.start(meleeAttackSpeed)
	if attackReady:
		if Input.is_action_pressed("heavy_attack"):
			PlayerHeavyMeleeAttack.emit()
			print("Heavy Attack")
			attackReady = false
			$MeleeAttackTimer.start(meleeAttackSpeed)


func _on_melee_attack_timer_timeout():
	attackReady = true


func _on_basic_enemy_player_hit() -> void:
	print("hit")
