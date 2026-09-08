extends Area2D
@onready var timer: Timer = $Timer
@onready var timer2: Timer = $AttackTimer
signal player_hit
var screen_size
var movement_direction: Vector2 = Vector2.ZERO
var player_position: Vector2 = Vector2.ZERO
var player_detect = false
@export var speed = 200
@export var damage = 5
@export var health = 30


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	randomize()
	timer.start()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = movement_direction 
	if player_detect:
		if player_position.y > position.y:
			velocity.y += 1
		if player_position.y < position.y:
			velocity.y -= 1
		if player_position.x > position.x:
			velocity.x += 1
		if player_position.x < position.x:
			velocity.x -= 1
		if velocity.length() > 0:
			velocity = velocity.normalized() * speed
		position += velocity * delta
		position = position.clamp(Vector2.ZERO, screen_size)
	else:
		choose_new_direction()


func choose_new_direction() -> void:
	var random_x = randf_range(-1.0, 1.0)
	var random_y = randf_range(-1.0, 1.0)
	movement_direction = Vector2(random_x, random_y).normalized()



func _on_timer_timeout() -> void:
	if !player_detect:
		choose_new_direction()
	timer.wait_time = randf_range(1.5, 4.0)


func _on_detection_area_area_entered(area: Area2D) -> void:
	player_detect = true


func _on_player_player_position(position: Variant) -> void:
	player_position.y = position.y
	player_position.x = position.x
	

func _on_player_area_entered(body: Node2D) -> void:
	timer2.start()


func _on_player_area_exited(body: Node2D) -> void:
	timer2.stop()


func _on_attack_timer_timeout() -> void:
	player_hit.emit()
