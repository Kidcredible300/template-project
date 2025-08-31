extends Button


@export var next_scene : PackedScene

# Autofocuses this button (for the controller players)
func _ready() -> void:
	grab_focus()


# Sets the scene to the next_scene variable when pressed
func _on_pressed() -> void:
	get_tree().change_scene_to_packed(next_scene)
