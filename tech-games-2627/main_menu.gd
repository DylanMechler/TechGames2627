extends Node

var tutorial_scene = preload("res://tutorial.tscn").instantiate()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_tutorial_button_pressed():
	get_tree().root.add_child(tutorial_scene) # Add the tutorial scene
	queue_free() # Delete the main menu scene


func _on_continue_button_pressed() -> void:
	print("Continue")


func _on_new_game_button_pressed() -> void:
	print("New Game")


func _on_unlockables_button_pressed() -> void:
	print("Unlockables")


func _on_settings_button_pressed() -> void:
	print("Settings")
