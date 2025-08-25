@tool
class_name ProductItem
extends GalleryItem

@export var price: int:
	get:
		return price
	set(value):
		if price != value:
			price = value
			changed.emit()
