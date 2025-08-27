class_name Utils


static func on_click(handler: Callable) -> Callable:
	return func(event: InputEvent):
		if event is InputEventMouseButton:
			if event.pressed:
				handler.call()
