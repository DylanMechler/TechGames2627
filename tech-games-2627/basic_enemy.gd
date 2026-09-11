extends Area2D
@onready var timer: Timer = $Timer
@onready var timer2: Timer = $AttackTimer
signal player_hit(damage)
var screen_size
var movement_direction: Vector2 = Vector2.ZERO
var player_position: Vector2 = Vector2.ZERO
var player_detect = false
@export var speed = 150
@export var damage = 5
@export var health = 30

 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	randomize()
	timer.start()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO
	if player_detect:
		velocity = (player_position - position).normalized() * speed
	else:
		velocity = movement_direction * speed
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if health <= 0:
		queue_free()


func choose_new_direction() -> void:
	var random_x = randf_range(-1.0, 1.0)
	var random_y = randf_range(-1.0, 1.0)
	movement_direction = Vector2(random_x, random_y).normalized()



func _on_timer_timeout() -> void:
	if !player_detect:
		choose_new_direction()
	timer.wait_time = randf_range(1.5, 4.0)


func _on_detection_area_area_entered(area: Area2D) -> void:
	print("ENTERED! Detected: ", area.name)
	player_detect = true


func _on_player_player_position(position: Variant) -> void:
	player_position.y = position.y
	player_position.x = position.x
	



func _on_attack_timer_timeout() -> void:
		player_hit.emit(damage)


func _on_detection_area_area_exited(area: Area2D) -> void:
	print("EXITED! Lost: ", area.name)
	player_detect = false


func _on_area_entered(area: Area2D) -> void:
	print("ATTACK START! BasicEnemy body touched: ", area.name, " | Is it DetectionArea? ", area.name == "DetectionArea")
	timer2.start()


func _on_area_exited(area: Area2D) -> void:
	print("ATTACK STOP! BasicEnemy body left: ", area.name)
	timer2.stop()


func _on_player_player_melee_attack(damage: Variant) -> void:
	health -= damage
