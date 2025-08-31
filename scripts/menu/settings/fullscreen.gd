extends OptionButton


const WINDOW_MODES : Array[DisplayServer.WindowMode] = [DisplayServer.WINDOW_MODE_WINDOWED, DisplayServer.WINDOW_MODE_FULLSCREEN, DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN]


func _ready() -> void:
	select(ConfigHandler.load_window_mode())
	_on_item_selected(ConfigHandler.load_window_mode())


func _on_item_selected(index: int) -> void:
	DisplayServer.window_set_mode(WINDOW_MODES[index])
	ConfigHandler.save_window_mode(index)
