extends Area2D

signal enemy_hit(enemy, bullet_damage)

var bullet_speed = 2000
var direction = 1
var bullet_damage = 0
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	velocity.x += 1
	velocity.x *= direction
	velocity = velocity.normalized() * bullet_speed
	position += velocity * delta
	if position.x <= -1000:
		queue_free()
	if position.x >= (screen_size.x + 1000):
		queue_free()


func _on_area_entered(area):
	enemy_hit.emit(area, bullet_damage)
	queue_free()
