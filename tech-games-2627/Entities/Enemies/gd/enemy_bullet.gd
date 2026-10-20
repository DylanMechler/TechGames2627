extends Area2D

signal player_hit(bullet_damage)

var bullet_speed = 750
var direction = 1
var bullet_damage = 0
var level_size

# Called when the node enters the scene tree for the first time.
func _ready():
	level_size = get_viewport_rect().size * 2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	velocity.x += 1
	velocity.x *= direction
	velocity = velocity.normalized() * bullet_speed
	position += velocity * delta
	if position.x <= -1000:
		queue_free()
	if position.x >= (level_size.x + 1000):
		queue_free()


func _on_area_entered(_area):
	player_hit.emit(bullet_damage)
	queue_free()
