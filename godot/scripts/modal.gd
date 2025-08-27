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
@export var button_close: Button
@export var hbox_images: HBoxContainer

var quantity: int:
	get:
		return quantity
	set(value):
		quantity = value
		label_quantity.text = str(quantity)
		var nb_images = hbox_images.get_child_count()
		if nb_images < quantity:
			for child in hbox_images.get_child_count():
				_show_image(child)
			for i in range(nb_images, quantity):
				hbox_images.add_child(image.duplicate())
				_show_image(i)
		elif nb_images > quantity:
			for i in quantity:
				_show_image(i)
			for i in range(quantity, nb_images):
				_hide_image(i)
		else:
			for child in hbox_images.get_child_count():
				_show_image(child)

var current_product: ProductItem:
	get:
		return current_product
	set(value):
		current_product = value
		image.texture = current_product.texture
		for child in hbox_images.get_children():
			child.texture = current_product.texture
		label_name.text = current_product.name

var image: TextureRect


func _init():
	image = TextureRect.new()
	image.visible = false
	image.scale = Vector2.ZERO
	image.add_child(CenteredPivot.new())


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self_modulate = Color(1, 1, 1, 0)
	modal.scale = Vector2.ZERO
	button_more.gui_input.connect(Utils.on_click(more))
	button_less.gui_input.connect(Utils.on_click(less))
	button_validate.gui_input.connect(Utils.on_click(validate))
	button_close.gui_input.connect(Utils.on_click(close))
	gui_input.connect(Utils.on_click(close))


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
	tween.parallel().tween_callback(func(): ticket.save_product(current_product, quantity))


func _show_image(i: int) -> void:
	var child: TextureRect = hbox_images.get_child(i)
	if not visible:
		child.show()
		return
	if child.visible:
		return

	var child_tween = child.create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	child_tween.tween_callback(
		func():
			child.scale = Vector2.ZERO
			child.show()
			_update_gap()
	)
	child_tween.tween_property(child, "scale", Vector2.ONE, 0.2)


func _hide_image(i: int) -> void:
	var child: Control = hbox_images.get_child(i)
	if not visible:
		child.hide()
		return
	if not child.visible:
		return

	var child_tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	child_tween.tween_property(child, "scale", Vector2.ZERO, 0.2)
	child_tween.tween_callback(child.hide)
	child_tween.tween_callback(_update_gap)


func _update_gap():
	if current_product:
		var needed_width = current_product.texture.get_width() * quantity
		var available_width = modal.size.x - 400
		var gaps_width = available_width - needed_width
		var gap = min(gaps_width / (quantity - 1), 40)
		hbox_images.add_theme_constant_override("separation", gap)
