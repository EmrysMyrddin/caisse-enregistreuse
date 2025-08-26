class_name TicketItemComponent
extends MarginContainer

@export var product: ProductItem:
	get:
		return product
	set(value):
		if product != value:
			if product:
				product.changed.disconnect(_product_changed)
			product = value
			if product:
				print("updating ticket entry product")
				product.changed.connect(_product_changed)
				label_name.text = product.name
				image.texture = product.texture
				label_unit_price.text = _price_to_string(product.price)

@export var quantity: int:
	get:
		return quantity
	set(value):
		print("updating ticket entry quantity")
		quantity = value
		label_quantity.text = "x" + str(quantity)
		if product:
			label_total_price.text = _price_to_string(product.price * quantity)

@export var label_quantity: Label
@export var label_name: Label
@export var label_unit_price: Label
@export var label_total_price: Label
@export var image: TextureRect
@export var button_more: Button
@export var button_less: Button


func _product_changed():
	self.product = product
	self.quantity = quantity


func _price_to_string(price: int) -> String:
	@warning_ignore("integer_division") return str(price / 100) + "," + str(price % 100) + "€"
