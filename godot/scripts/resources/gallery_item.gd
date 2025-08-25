@tool
class_name GalleryItem
extends Resource

@export var name: String:
	get:
		return name
	set(value):
		if value != name:
			name = value
			changed.emit()

@export var texture: Texture2D:
	get:
		return texture
	set(value):
		if value != texture:
			texture = value
			changed.emit()
