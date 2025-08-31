extends Node


const KEYBINDING_SETS : int = 2
const INPUTS : Array[String] = ["forward", "left", "backward", "right", "jump", "sprint"]

var config = ConfigFile.new()
const SETTINGS_FILE_PATH = "user://settings.ini"

func _ready() -> void:
	if !FileAccess.file_exists(SETTINGS_FILE_PATH):
		# Save Keybinding Settings
		InputMap.load_from_project_settings()
		for input : String in INPUTS:
			var events : Array = InputMap.action_get_events(input)
			for i in range(KEYBINDING_SETS):
				config.set_value("Keybinding"+str(i), input, events[i].as_text())
		
		#Save Graphical Settings
		config.set_value("video", "window_mode", 0)
		
		# Save Audio Settings
		config.set_value("audio", "Master", 1.0)
		config.set_value("audio", "Music", 1.0)
		config.set_value("audio", "Sound", 1.0)
		
		# Save the Config File
		config.save(SETTINGS_FILE_PATH)
	else:
		config.load(SETTINGS_FILE_PATH)


func save_window_mode(value : int) -> void:
	config.set_value("video", "window_mode", value)
	config.save(SETTINGS_FILE_PATH)


func load_window_mode() -> int:
	return config.get_value("video", "window_mode")


func save_audio_setting(key : String, value : float) -> void:
	config.set_value("audio", key, value)
	config.save(SETTINGS_FILE_PATH)


func load_audio_setting(key : String) -> float:
	return config.get_value("audio", key)
