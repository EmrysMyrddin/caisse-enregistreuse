extends LineEdit


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text_changed.connect(
		func(new_text: String):
			var pos = caret_column
			text = new_text.to_upper()
			caret_column = pos
	)
