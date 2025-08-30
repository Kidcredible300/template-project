extends OptionButton


const WINDOW_MODES : Array[DisplayServer.WindowMode] = [DisplayServer.WINDOW_MODE_WINDOWED, DisplayServer.WINDOW_MODE_FULLSCREEN, DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN]


func _ready() -> void:
	for i in range(WINDOW_MODES.size()):
		if DisplayServer.window_get_mode() == WINDOW_MODES[i]:
			selected = i


func _on_item_selected(index: int) -> void:
	DisplayServer.window_set_mode(WINDOW_MODES[index])
