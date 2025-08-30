extends HSlider


@export var bus_name : String
@onready var bus : int = AudioServer.get_bus_index(bus_name)


func _ready() -> void:
	AudioServer.set_bus_volume_linear(bus, GlobalSettings.get_volume(bus_name))
	value = AudioServer.get_bus_volume_linear(bus)


func _on_value_changed(val: float) -> void:
	AudioServer.set_bus_volume_linear(bus, val)
	GlobalSettings.set_volume(bus_name, val)
