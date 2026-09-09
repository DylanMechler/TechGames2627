extends Node
@onready var option_button: OptionButton = $OptionButton
@onready var confirm_button: Button = $ConfirmButton
var chara_saved_index: int = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_confirm_button_pressed() -> void:
	chara_saved_index = option_button.selected
	print("Selected Character: ", chara_saved_index)
