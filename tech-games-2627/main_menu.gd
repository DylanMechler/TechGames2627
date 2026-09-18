extends Node

const tutorial_scene = preload("res://tutorial.tscn")
const chara_select_scene = preload("res://chara_select_scene.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	if get_tree().current_scene == null:
		get_tree().current_scene = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_tutorial_button_pressed():
	get_tree().change_scene_to_file("res://tutorial.tscn")


func _on_continue_button_pressed():
	print("Continue")


func _on_new_game_button_pressed():
	get_tree().change_scene_to_file("res://chara_select_scene.tscn")


func _on_unlockables_button_pressed():
	print("Unlockables")


func _on_settings_button_pressed():
	print("Settings")
