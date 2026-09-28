extends Node2D

@export var ranged_enemy_scene: PackedScene
var enemies = [[500, 500], [200, 200]]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for enemy in enemies:
		var new_enemy = ranged_enemy_scene.instantiate()
		new_enemy.position.x = enemy[0]
		new_enemy.position.y = enemy[1]
		add_child(new_enemy)
		new_enemy.add_to_group("enemies")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
