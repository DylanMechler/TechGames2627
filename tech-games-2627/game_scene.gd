extends Node

@export var basic_enemy_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
		var enemy = basic_enemy_scene.instantiate()
		enemy.position.x = randf_range(0, 500)
		enemy.position.y = randf_range(0, 500)
		add_child(enemy)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
