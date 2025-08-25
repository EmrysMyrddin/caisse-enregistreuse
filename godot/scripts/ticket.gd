class_name Ticket
extends VBoxContainer

const ticket_item_component = preload("res://scenes/components/ticket_item.tscn")

@export var label_total: Label

var basket: Dictionary[ProductItem, int] = {}
var basket_components: Dictionary[ProductItem, TicketItemComponent] = {}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass  # Replace with function body.


func add_product(product: ProductItem, quantity: int):
	print("adding product to ticket")
	if not product in basket:
		print("new product, adding to basket")
		basket[product] = quantity
		var component = ticket_item_component.instantiate()
		basket_components[product] = component
		component.product = product
		component.name = "Entry - " + product.name
		component.more.connect(func(): add_product(product, 1))
		component.less.connect(func(): add_product(product, -1))
		add_child(component)
	else:
		print("product exists, updating basket")
		basket[product] += quantity

	if basket[product] <= 0:
		basket_components[product].queue_free()
		basket_components.erase(product)
		basket.erase(product)
	else:
		basket_components[product].quantity = basket[product]

	_update_total()


func _update_total() -> void:
	var total = 0

	for product in basket:
		total += basket[product] * product.price

	@warning_ignore('integer_division')
	label_total.text = str(total / 100) + "," + str(total % 100) + "€"


func _basket_entry_string(product: ProductItem) -> String:
	return "x" + str(basket[product]) + " " + product.name
