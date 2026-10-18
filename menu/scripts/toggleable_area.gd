class_name TogglebleArea extends Control


@export var button : Button
@export var focus : Control
@export var other_area : TogglebleArea


func _ready() -> void:
	if button:
		button.connect("pressed", _swap)


func _swap() -> void:
	if other_area:
		hide()
		other_area.reveal()


func reveal() -> void:
	focus.grab_focus()
	show()
