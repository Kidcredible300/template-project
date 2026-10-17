extends Control


const RESOLUTIONS : Dictionary = {
	"3840x2160": Vector2i(3840,2160),
	"3440x1440": Vector2i(3440,1440),
	"2560x1440": Vector2i(2560,1440),
	"2560x1600": Vector2i(2560, 1600),
	"1920x1080": Vector2i(1920,1080),
	"1920x1200": Vector2i(1920,1200),
	"1366x768": Vector2i(1366,768),
	"1280x720": Vector2i(1280,720),
	"1280x800": Vector2i(1280,800)
}
const DEFAULT_RESOLUTION : String = "1920x1080"
const DEFAULT_RESOLUTION_INDEX : int = 4
const DISPLAY_MODES : Dictionary = {
	"Windowed" : Window.MODE_WINDOWED,
	"Borderless" : Window.MODE_FULLSCREEN,
	"Fullscreen" : Window.MODE_EXCLUSIVE_FULLSCREEN
}
const METHODS : Array = ["mode_selected", "resolution_selected", "toggle_vsync", "set_fps_cap"]
const NAMES : Array = ["mode", "resolution", "vsync", "fps"]
@onready var display_mode_button : OptionButton = $"Display Mode/OptionButton"
@onready var resolutions_option_button : OptionButton = $Resolution/OptionButton
@onready var vsync_button : CheckBox = $VSync/CheckBox
@onready var fps_input : SpinBox = $"FPS Limit/SpinBox"


func _ready() -> void:
	apply_dict(display_mode_button, DISPLAY_MODES)
	apply_dict(resolutions_option_button, RESOLUTIONS)
	resolutions_option_button.select(DEFAULT_RESOLUTION_INDEX)
	load_values()
	vsync_button.connect("toggled", toggle_vsync)
	fps_input.connect("value_changed", set_fps_cap)
	display_mode_button.connect("item_selected", mode_selected)
	resolutions_option_button.connect("item_selected", resolution_selected)


func apply_dict(button : OptionButton, dict : Dictionary) -> void:
	for d in dict:
		button.add_item(d)


func mode_selected(index : int) -> void:
	var mode : Window.Mode = DISPLAY_MODES.get(display_mode_button.get_item_text(index))
	display_mode_button.selected = index
	get_window().mode = mode
	if mode == Window.MODE_WINDOWED:
		get_window().move_to_center()
		place_window()
	save_value("mode", index)

func resolution_selected(index : int) -> void:
	var size : Vector2i = RESOLUTIONS.get(resolutions_option_button.get_item_text(index))
	resolutions_option_button.selected = index
	get_window().content_scale_size = size
	place_window()
	save_value("resolution", index)


func place_window() -> void:
	var center : Vector2i = get_window().position + get_window().size/2
	get_window().size = get_window().content_scale_size
	get_window().position = center - get_window().content_scale_size/2


func toggle_vsync(turn_on : bool) -> void:
	vsync_button.set_pressed_no_signal(turn_on)
	if turn_on:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		fps_input.editable = false
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		fps_input.editable = true
	save_value("vsync", turn_on)

func set_fps_cap(cap : float) -> void:
	Engine.max_fps = cap
	save_value("fps", cap)
	fps_input.set_value_no_signal(cap)


func save_value(name : String, value : Variant):
	SimpleSettings.load()
	print("saving")
	SimpleSettings.set_value("settings", "video/"+name, value)
	SimpleSettings.save()
	print(SimpleSettings.get_value("settings", "video/fps"))


func load_values() -> void:
	SimpleSettings.load()
	if SimpleSettings.has_section("settings", "video"):
		for i in range(METHODS.size()):
			call(METHODS[i], SimpleSettings.get_value("settings", "video/"+NAMES[i]))
	else:
		save_value("mode", 0)
		save_value("resolution", DEFAULT_RESOLUTION_INDEX)
		save_value("vsync", true)
		save_value("fps", 120)
