extends Panel

var current_focus: Control


func _ready() -> void:
	get_viewport().gui_focus_changed.connect(func(control: Control): current_focus = control)


func _gui_input(event: InputEvent) -> void:
	if (
		current_focus
		and event is InputEventMouseButton
		and not current_focus.get_global_rect().has_point(event.global_position)
	):
		current_focus.release_focus()
