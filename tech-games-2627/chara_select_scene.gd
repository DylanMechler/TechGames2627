extends Node
@onready var option_button: OptionButton = $OptionButton
@onready var confirm_button: Button = $ConfirmButton
var chara_saved_index: int = 1
var chara_saved_text: String = ""
const GAME_SCENE = preload("res://game_scene.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_confirm_button_pressed() -> void:
	chara_saved_index = option_button.selected
	chara_saved_text = option_button.get_item_text(chara_saved_index)
	if chara_saved_index == -1:
		print("No Selection!")
	else:
		print("Selected Character: ", chara_saved_index, " ", chara_saved_text)
		var new_scene = GAME_SCENE.instantiate()
		get_tree().root.add_child(new_scene)
		queue_free()
