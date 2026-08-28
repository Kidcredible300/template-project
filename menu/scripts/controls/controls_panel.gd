extends Panel


@export var action : String = "left"
@onready var label : Label = $"MarginContainer/HBoxContainer/Input Name"
@onready var buttons : HBoxContainer = $MarginContainer/HBoxContainer/Buttons
@onready var button : PackedScene = load("res://menu/scenes/controls/controls_button.tscn")
var collecting_input : bool = false
var input_button : ControlsButton


func _ready() -> void:
	label.text = action.capitalize()
	var actions : Array = InputMap.action_get_events(action)
	var keyboard_actions : Array = []
	var gamepad_actions : Array = []
	for i in range(4):
		var event : InputEvent
		if actions.size() > i:
			event = actions[i]
		var local_button : ControlsButton = button.instantiate()
		var treat_like_keyboard : bool = false
		if !event:
			treat_like_keyboard = keyboard_actions.size() < gamepad_actions.size()
		else:
			local_button.controls_index = i
			treat_like_keyboard = _is_keyboard(event)
		if treat_like_keyboard:
			keyboard_actions.append(local_button)
		else:
			gamepad_actions.append(local_button)
	var final_array : Array = keyboard_actions
	final_array.append_array(gamepad_actions)
	for local_button : ControlsButton in final_array:
		buttons.add_child(local_button)
		local_button.positional_index = local_button.get_index()
		local_button.action = action
		local_button.connect("input_requested", start_keybind_change)
		local_button.set_input_icon()


func start_keybind_change(local_button : ControlsButton) -> void:
	collecting_input = true
	input_button = local_button
	local_button.get_child(0).hide()
	local_button.text = "INPUT"


func end_keybind_change() -> void:
	collecting_input = false
	input_button.set_input_icon()
	input_button.text = ""
	input_button = null


func _input(event: InputEvent) -> void:
	if collecting_input:
		if (event is InputEventJoypadMotion and abs(event.axis_value) < 0.1) || event is InputEventMouseMotion:
			accept_event()
			return
		var keyboard : bool = _is_keyboard(event)
		var gamepad : bool = _is_gamepad(event)
		if !(keyboard || gamepad):
			return
		if Input.is_action_pressed("ui_cancel"):
			if input_button.controls_index > -1:
				_remove_binding()
			else:
				end_keybind_change()
			accept_event()
		elif input_button.positional_index in [0,1]:
			if keyboard:
				_remap(event)
				accept_event()
			else:
				end_keybind_change()
				accept_event()
		elif input_button.positional_index in [2,3]:
			if gamepad:
				_remap(event)
				accept_event()
			else:
				end_keybind_change()
				accept_event()


func _is_gamepad(event : InputEvent) -> bool:
	return event.get_class() in ["InputEventJoypadButton", "InputEventJoypadMotion"]

func _is_keyboard(event : InputEvent) -> bool:
	return event.get_class() in ["InputEventKey", "InputEventMouseButton"]

func _remap(event : InputEvent) -> void:
	# Avoid double clicks
	if event is InputEventMouseButton and event.double_click:
		event.double_click = false
	# Avoid a weird error with gamepad joysticks
	if event is InputEventJoypadMotion:
		if event.axis_value < 0:
			event.axis_value = -1
		if event.axis_value > 0:
			event.axis_value = 1
	var events : Array = InputMap.action_get_events(action)
	InputMap.action_erase_events(action)
	var keyboard_events : Array = []
	var gamepad_events : Array = []
	for local_event : InputEvent in events:
		if _is_keyboard(local_event):
			keyboard_events.append(local_event)
		else:
			gamepad_events.append(local_event)
	if _is_keyboard(event):
		keyboard_events = _set_events(keyboard_events, event, 0)
	else:
		gamepad_events = _set_events(gamepad_events, event, keyboard_events.size())
	var good_array = keyboard_events
	good_array.append_array(gamepad_events)
	for i in good_array:
		InputMap.action_add_event(action, i)
	end_keybind_change()


func _remove_binding() -> void:
	var events : Array = InputMap.action_get_events(action)
	InputMap.action_erase_events(action)
	var keyboard_events : Array = []
	var gamepad_events : Array = []
	for local_event : InputEvent in events:
		if _is_keyboard(local_event):
			keyboard_events.append(local_event)
		else:
			gamepad_events.append(local_event)
	if input_button.positional_index in [0,1]:
		keyboard_events = _set_events(keyboard_events, null, 0)
	else:
		gamepad_events = _set_events(gamepad_events, null, 2)
	var good_array = keyboard_events
	good_array.append_array(gamepad_events)
	for i in good_array:
		InputMap.action_add_event(action, i)
	input_button.controls_index = -1
	end_keybind_change()


func _set_events(event_array : Array, event : Object, index_addition : int) -> Array:
	for i : InputEvent in event_array:
		if i.is_match(event):
			return event_array
	if event_array.has(event):
		return event_array
	if event_array.size() <= 0:
		event_array.append(event)
		input_button.controls_index = index_addition
	elif event_array.size() == 1:
		var other_button : ControlsButton = buttons.get_child(_get_other_button(input_button.positional_index))
		if other_button.controls_index > -1:
			if other_button.positional_index < input_button.positional_index:
				event_array.append(event)
				input_button.controls_index = index_addition+1
			else:
				event_array.insert(0, event)
				input_button.controls_index = index_addition
		else:
			event_array.set(0, event)
			input_button.controls_index = input_button.positional_index
	elif event_array.size() == 2:
		event_array.set(input_button.controls_index-index_addition, event)
	var final_array : Array
	for i in event_array:
		if i != null:
			final_array.append(i)
	return final_array


func _get_other_button(index : int) -> int:
	match index:
		0:
			return 1
		1:
			return 0
		2:
			return 3
		3:
			return 2
	return 0
