@tool
class_name CenteredPivot
extends Node

@onready var parent: Control = get_parent()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if parent is Control:
		parent.pivot_offset = parent.size / 2
		parent.resized.connect(
			func():
				parent.pivot_offset = parent.size / 2
				print("pivot re-centered")
		)
