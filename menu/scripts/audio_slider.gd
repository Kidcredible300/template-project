class_name AudioSlider extends VBoxContainer


@onready var label : Label = $Label
@onready var slider : HSlider = $HSlider
@export var track : String = "Master"

signal volume_change(track : String, new : float)


func _ready() -> void:
	label.text = track+" Volume"
	slider.connect("drag_ended", change)


func change(_something) -> void:
	volume_change.emit(track, slider.value)


func focus() -> void:
	slider.grab_focus(true)


func set_value(value : float) -> void:
	slider.value = value
