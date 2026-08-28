extends Button


@onready var controls_manager : Control = $"../../ScrollContainer/ControlsManager"


func _ready() -> void:
	connect("pressed", _on_pressed)


func _on_pressed() -> void:
	InputMap.load_from_project_settings()
	controls_manager.reset_children()
