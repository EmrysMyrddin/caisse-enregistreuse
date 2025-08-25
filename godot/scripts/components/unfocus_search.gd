extends Panel

@export var search_input: LineEdit


func _gui_input(event: InputEvent) -> void:
	if (
		event is InputEventMouseButton
		and not search_input.get_global_rect().has_point(event.global_position)
	):
		search_input.release_focus()
