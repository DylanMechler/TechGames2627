extends Node

const tutorial_scene = preload("res://tutorial.tscn")
const chara_select_scene = preload("res://chara_select_scene.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_tutorial_button_pressed():
	var tutorial = tutorial_scene.instantiate()
	get_tree().root.add_child(tutorial) # Add the tutorial scene
	queue_free() # Delete the main menu scene


func _on_continue_button_pressed():
	print("Continue")


func _on_new_game_button_pressed():
	var character_select = chara_select_scene.instantiate()
	get_tree().root.add_child(character_select) # Add the character select scene
	queue_free() # Delete the main menu scene


func _on_unlockables_button_pressed():
	print("Unlockables")


func _on_settings_button_pressed():
	print("Settings")
