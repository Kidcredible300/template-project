extends PanelContainer

@export var input_set : int = 0
@export var keyboard_sets : Array[int] = [0]
@export var gamepad_sets : Array[int] = [1]
@export var inputs : Array[String] = ["forward", "left", "backward", "right", "jump", "sprint"]

var input_dict : Dictionary

var is_remapping : bool = false
var action_to_remap = null
var remapping_button = null

@onready var input_button : PackedScene = preload("res://scenes/menu/input_button.tscn")
@onready var action_list = $"MarginContainer/VBoxContainer/ScrollContainer/Action List"

func _ready() -> void:
	_make_input_dictionary()
	_create_action_list()


func _make_input_dictionary() -> void:
	for input : String in inputs:
		var fancy : String = input
		input[0] = input[0].to_upper()
		for i in input.length():
			var char : String = input[i]
			if char == "_":
				input[i] = " "
				if i+1 < input.length():
					input[i+1] = input[i+1].to_upper()
		input_dict[fancy] = input


func _input(event: InputEvent) -> void:
	if is_remapping:
		if input_set in keyboard_sets:
			if event.get_class() in ["InputEventKey", "InputEventMouseButton"]:
				_remap(event)
			else:
				_finish_mapping()
		if input_set in gamepad_sets:
			if event.get_class() in ["InputEventJoypadButton", "InputEventJoypadMotion"]:
				_remap(event)
			else:
				_finish_mapping()
		accept_event()


func _remap(event : InputEvent) -> void:
	# Avoid double clicks
	if event is InputEventMouseButton and event.double_click:
		event.double_click = false
	var events : Array = InputMap.action_get_events(action_to_remap)
	InputMap.action_erase_events(action_to_remap)
	for i : int in range(events.size()):
		if i == input_set:
			InputMap.action_add_event(action_to_remap, event)
		else:
			InputMap.action_add_event(action_to_remap, events[i])
	events = InputMap.action_get_events(action_to_remap)
	_finish_mapping()


func _finish_mapping() -> void:
	var events : Array = InputMap.action_get_events(action_to_remap)
	remapping_button.find_child("Label Input").text = _fix_input_name(events[input_set].as_text())
	
	is_remapping = false
	action_to_remap = null
	remapping_button = null


func _create_action_list() -> void:
	InputMap.load_from_project_settings()
	for item in action_list.get_children():
		item.queue_free()
	
	for action in input_dict:
		var button : Button = input_button.instantiate()
		var action_text : Label = button.find_child("Label Action")
		var input_text : Label = button.find_child("Label Input")
		action_text.text = input_dict[action]
		var events = InputMap.action_get_events(action)
		if events.size() > 0:
			input_text.text = _fix_input_name(events[input_set].as_text())
		else:
			input_text.text = ""
		action_list.add_child(button)
		button.pressed.connect(_on_input_button_pressed.bind(button, action))


func _on_input_button_pressed(button, action) -> void:
	if is_remapping:
		return
	is_remapping = true
	action_to_remap = action
	remapping_button = button
	if input_set in keyboard_sets:
		button.find_child("Label Input").text = "Press key to bind..."
	elif input_set in gamepad_sets:
		button.find_child("Label Input").text = "Press button to bind..."
	else:
		button.find_child("Label Input").text = "Press to bind..."


func _fix_input_name(input : String) -> String:
	if input_set in gamepad_sets:
		var fancy : String
		if input.contains("Joypad Motion"):
			var cardinal_directions = {true : {true : " -1 (Up)", false : " 1 (Down)"}, false : {true : "-1 (Left)", false : "1 (Right)"} }
			fancy += input.substr(input.find("(")+1, input.find("Axis")) + " "
			fancy += cardinal_directions[input.contains("Y-Axis")][input.contains("-1")]
		elif input.contains("Joypad Button"):
			if input.trim_prefix("Joypad Button ").is_valid_int():
				fancy = input
			else:
				fancy += input.substr(input.find("(")+1)
				fancy = fancy.substr(0, fancy.length()-1)
		else:
			fancy = input
		return fancy
	elif input_set in keyboard_sets:
		return input.trim_suffix(" (Physical)")
	else:
		return ""


func _on_reset_button_pressed() -> void:
	_create_action_list()
