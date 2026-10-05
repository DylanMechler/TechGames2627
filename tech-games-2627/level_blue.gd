extends Node2D

@export var basic_enemy_scene: PackedScene
@export var ranged_enemy_scene: PackedScene
var enemies = [[500, 500, "melee"], [200, 200, "melee"]]

# Called when the node enters the scene tree for the first time.
func _ready():
	for enemy in enemies:
		var new_enemy
		match enemy[2]:
			"melee":
				new_enemy = basic_enemy_scene.instantiate()
			"ranged":
				new_enemy = ranged_enemy_scene.instantiate()
		new_enemy.position.x = enemy[0]
		new_enemy.position.y = enemy[1]
		add_child(new_enemy)
		new_enemy.add_to_group("enemies")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_deltat):
	pass
