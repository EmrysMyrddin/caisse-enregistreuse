class_name TicketItemComponent
extends MarginContainer

signal less
signal more

@export var product: ProductItem:
	get:
		return product
	set(value):
		if product != value:
			if product:
				product.changed.disconnect(_update)
			product = value
			if product:
				product.changed.connect(_update)
			_update()

@export var quantity: int:
	get:
		return quantity
	set(value):
		if quantity != value:
			quantity = value
			_update()

@export var label_quantity: Label
@export var label_name: Label
@export var image: TextureRect
@export var button_more: Button
@export var button_less: Button


func _ready() -> void:
	button_more.pressed.connect(func(): more.emit())
	button_less.pressed.connect(func(): less.emit())


func _update():
	if product:
		label_name.text = product.name
		image.texture = product.texture

	label_quantity.text = "x" + str(quantity)
