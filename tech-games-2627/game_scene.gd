extends Node

signal player_attacked(damage)

@export var basic_enemy_scene: PackedScene
var enemies = [[500, 500], [400, 400], [300, 300], [200, 200]]
var loaded_enemies = []


# Called when the node enters the scene tree for the first time.
func _ready():
	for enemy in enemies:
		var new_enemy = basic_enemy_scene.instantiate()
		new_enemy.position.x = enemy[0]
		new_enemy.position.y = enemy[1]
		add_child(new_enemy)
		new_enemy.player_hit.connect(_on_basic_enemy_player_hit)
		loaded_enemies.append(new_enemy)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_basic_enemy_player_hit(damage):
	player_attacked.emit(damage)

func _on_player_player_position(position: Variant) -> void:
	for enemy in loaded_enemies:
		enemy.player_position = position
