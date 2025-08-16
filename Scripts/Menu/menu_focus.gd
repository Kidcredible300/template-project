extends VBoxContainer


@export var first_element : Control


func _ready() -> void:
	connect("visibility_changed", focus_element)


func focus_element() -> void:
	if visible:
		first_element.grab_focus()
