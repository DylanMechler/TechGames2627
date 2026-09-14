extends CanvasLayer
const GAME_SCENE = preload("res://game_scene.tscn")
const MAIN_MENU_SCENE = preload("res://main_menu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_restart_button_pressed() -> void:
	var game_scene = GAME_SCENE.instantiate()
	get_tree().root.add_child(game_scene)
	queue_free()


func _on_main_menu_button_pressed() -> void:
	var main_menu_scene = MAIN_MENU_SCENE.instantiate()
	get_tree().root.add_child(main_menu_scene)
	queue_free()
