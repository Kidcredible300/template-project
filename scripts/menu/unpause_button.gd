extends Button


# Autofocuses this button (for the controller players)
func _ready() -> void:
	grab_focus()


func _on_pressed() -> void:
	GameManager.unpause()
