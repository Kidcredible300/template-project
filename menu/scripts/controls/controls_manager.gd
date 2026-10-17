extends VBoxContainer


@onready var controls_panel : PackedScene = load("res://menu/scenes/controls/controls_panel.tscn")
const EXCLUDE_LIST = ["ui_"]


func _ready() -> void:
	load_controls()


func reset_children() -> void:
	for i in get_children():
		remove_child(i)
	for i in InputMap.get_actions():
		if !_in_exclude_list(i):
			var panel = controls_panel.instantiate()
			panel.action = i
			add_child(panel)


func _in_exclude_list(action : String) -> bool:
	for i in EXCLUDE_LIST:
		if action.contains(i):
			return true
	return false


func save_controls() -> void:
	SimpleSettings.load()
	for i in InputMap.get_actions():
		if !_in_exclude_list(i):
			var events : Array[InputEvent] = InputMap.action_get_events(i)
			SimpleSettings.set_value("settings", "controls/"+i, events)
	SimpleSettings.save()
	load_controls()


func load_controls() -> void:
	SimpleSettings.load()
	if SimpleSettings.has_section("settings", "controls"):
		var sections : Array = SimpleSettings.get_section_keys("settings", "controls")
		if sections.size() <= 0:
			InputMap.load_from_project_settings()
			reset_children()
			return
		for i : String in sections:
			if !_in_exclude_list(i):
				InputMap.action_erase_events(i)
				for j in SimpleSettings.get_value("settings", "controls/"+i):
					InputMap.action_add_event(i, j)
	reset_children()
