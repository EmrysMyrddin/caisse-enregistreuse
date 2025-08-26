class_name Modal
extends Panel

var tween: Tween

@export var ticket: Ticket
@export var modal: Panel
@export var label_name: Label
@export var label_quantity: Label
@export var button_less: Button
@export var button_more: Button
@export var button_validate: Button
@export var hbox_images: HBoxContainer

var quantity: int:
	get:
		return quantity
	set(value):
		quantity = value
		label_quantity.text = str(quantity)
		var nb_images = hbox_images.get_child_count()
		if nb_images < quantity:
			for child in hbox_images.get_children():
				child.show()
			for i in range(nb_images, quantity):
				hbox_images.add_child(image.duplicate())
		elif nb_images > quantity:
			for i in quantity:
				hbox_images.get_child(i).show()
			for i in range(quantity, nb_images):
				hbox_images.get_child(i).hide()
		else:
			for child in hbox_images.get_children():
				child.show()

var current_product: ProductItem:
	get:
		return current_product
	set(value):
		current_product = value
		image.texture = current_product.texture
		label_name.text = current_product.name

var image: TextureRect


func _init():
	image = TextureRect.new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self_modulate = Color(1, 1, 1, 0)
	modal.scale = Vector2.ZERO
	button_more.gui_input.connect(_on_click(more))
	button_less.gui_input.connect(_on_click(less))
	button_validate.gui_input.connect(_on_click(validate))


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		close()


func open(product: ProductItem, default_quantity: int):
	self.quantity = default_quantity
	self.current_product = product

	if tween:
		tween.kill()
	show()
	tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "self_modulate", Color(1, 1, 1, 1), 0.3)
	tween.parallel().tween_property(modal, "scale", Vector2.ONE, 0.3)


func close():
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "self_modulate", Color(1, 1, 1, 0), 0.3)
	tween.parallel().tween_property(modal, "scale", Vector2.ZERO, 0.3)
	tween.tween_callback(hide)


func more():
	self.quantity += 1


func less():
	self.quantity -= 1


func validate():
	close()
	tween.parallel().tween_callback(func(): ticket.add_product(current_product, quantity))


func _on_click(handler: Callable) -> Callable:
	return func(event: InputEvent):
		if event is InputEventMouseButton:
			if event.pressed:
				handler.call()
