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
@onready var display_mode_button = $"Display Mode/OptionButton"
@onready var resolutions_option_button = $Resolution/OptionButton


func _ready() -> void:
	display_mode_button.connect("item_selected", mode_selected)
	resolutions_option_button.connect("item_selected", resolution_selected)
	apply_dict(display_mode_button, DISPLAY_MODES)
	apply_dict(resolutions_option_button, RESOLUTIONS)
	resolutions_option_button.select(DEFAULT_RESOLUTION_INDEX)


func apply_dict(button : OptionButton, dict : Dictionary) -> void:
	for d in dict:
		button.add_item(d)


func mode_selected(index : int) -> void:
	var mode : Window.Mode = DISPLAY_MODES.get(display_mode_button.get_item_text(index))
	get_window().mode = mode
	if mode == Window.MODE_WINDOWED:
		get_window().move_to_center()
		place_window()

func resolution_selected(index : int) -> void:
	var size : Vector2i = RESOLUTIONS.get(resolutions_option_button.get_item_text(index))
	get_window().content_scale_size = size
	place_window()


func place_window() -> void:
	var center : Vector2i = get_window().position + get_window().size/2
	get_window().size = get_window().content_scale_size
	get_window().position = center - get_window().content_scale_size/2
