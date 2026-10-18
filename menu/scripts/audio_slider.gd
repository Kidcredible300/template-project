class_name AudioSlider extends VBoxContainer


@onready var label : Label = $Label
@onready var slider : HSlider = $HSlider
@export var track : String = "Master"

signal volume_change(track : String, new : float)


func _ready() -> void:
	label.text = track+" Volume"
	slider.connect("drag_ended", change)
	load_volume()


func load_volume() -> void:
	SimpleSettings.load()
	if SimpleSettings.has_section("settings", "audio") and SimpleSettings.has_section_key("settings", "audio/"+track):
		set_value(SimpleSettings.get_value("settings", "audio/"+track))
		volume_change.emit(track, slider.value)
	else:
		save_volume()

func save_volume() -> void:
	SimpleSettings.load()
	SimpleSettings.set_value("settings", "audio/"+track, slider.value)
	SimpleSettings.save()


func change(_something) -> void:
	volume_change.emit(track, slider.value)
	save_volume()


func focus() -> void:
	slider.grab_focus(true)


func set_value(value : float) -> void:
	slider.value = value
