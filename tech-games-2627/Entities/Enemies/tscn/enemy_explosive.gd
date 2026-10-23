extends Area2D

signal player_hit(damage)

var enemy_location = Vector2.ZERO
var damage = 0
var spawned = false
var activated = false
var player_in_radius = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if !spawned:
		var explosive_distance = Vector2(randf_range(-400.0, 400.0), randf_range(-400.0, 400.0))
		position = enemy_location + explosive_distance
		if position.x < 0:
			position.x = 0
		if position.y < 0:
			position.y = 0
		spawned = true
		$AnimatedSprite2D.animation = "stage_1"
		$AnimatedSprite2D.play()
		$Stage1Timer.start()


func _on_stage_1_timer_timeout():
	$AnimatedSprite2D.animation = "stage_2"
	$Stage2Timer.start()


func _on_stage_2_timer_timeout():
	$AnimatedSprite2D.animation = "stage_3"
	if player_in_radius:
		player_hit.emit(damage)
	print("EXPLOSION")
	queue_free()


func _on_area_entered(_area):
	player_in_radius = true
	print("IN RADIUS")


func _on_area_exited(_area):
	player_in_radius = false
	print("OUT OF RADIUS")
