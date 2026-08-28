class_name ControlsButton extends Button


var positional_index : int = 0
var controls_index : int = -1
var action : String = ""
@onready var input_icon : InputIconTextureRect = $InputIconTextureRect

signal input_requested(button : ControlsButton)


func _ready() -> void:
	connect("pressed", press)


func press() -> void:
	input_requested.emit(self)


func set_input_icon() -> void:
	if controls_index > -1:
		input_icon.action_name = action
		input_icon.event_index = controls_index
		input_icon.show()
	else:
		input_icon.hide()
