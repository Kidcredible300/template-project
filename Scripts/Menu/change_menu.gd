extends Button


@export var to_hide : Control
@export var to_show : Control


# Shows and hides the respective nodes
func _on_pressed() -> void:
	# Make sure the button is no longer focused when hidden
	release_focus()
	to_hide.hide()
	to_show.show()
