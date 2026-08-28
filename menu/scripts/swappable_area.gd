extends MarginContainer


@export var areas : Array[Control]
@export var to_focus : Array[Control]
@export var buttons : Array[Button]
var focused : int = 0


func _ready() -> void:
	for i : Button in buttons:
		i.connect("pressed", pressed)
	for i : Control in areas:
		i.hide()
	areas[focused].show()


func pressed() -> void:
	var index : int = 0
	for i : int in range(buttons.size()):
		if buttons.get(i).is_pressed():
			index = i
	areas[focused].hide()
	areas[index].show()
	if to_focus.size()>index:
		if to_focus[index] is AudioSlider:
			to_focus[index].focus()
		else:
			to_focus[index].grab_focus()
	focused = index
