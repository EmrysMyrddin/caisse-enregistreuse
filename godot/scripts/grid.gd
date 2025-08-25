@tool
class_name Gallery
extends GridContainer

const item_scene = preload("res://scenes/components/gallery_item.tscn")

@export var ticket: Ticket

@export var grid_size: Vector2i:
	get:
		return grid_size
	set(value):
		if grid_size != value:
			grid_size = value
			columns = grid_size.x
			update_items_containers()

@export var categories: Array[CategoryItem]:
	get:
		return categories
	set(value):
		if !items or !is_showing_category():
			self.items = value
		categories = value

@export var items: Array:
	get:
		return items
	set(new_items):
		items = new_items
		feed_items_containers()

var back_item: BackItem


func _init():
	back_item = BackItem.new()
	back_item.texture = preload("res://assets/icon.svg")
	back_item.name = "Retour"


func _get_configuration_warnings() -> PackedStringArray:
	if !ticket:
		return ["Missing ticket node"]
	return []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child: GalleryItemComponent in get_children():
		child.clicked.connect(_on_item_clicked)
	update_items_containers()


func update_items_containers():
	if not is_node_ready():
		return

	var nb_children = get_child_count()
	var target_nb_containers = grid_size.x * grid_size.y

	if nb_children > target_nb_containers:
		for i in range(target_nb_containers, nb_children):
			_remove_item_slot(i)
	elif nb_children < target_nb_containers:
		for i in range(nb_children, target_nb_containers):
			_add_item_slot(i)

	feed_items_containers()


func feed_items_containers():
	var nb_children = get_child_count()
	if nb_children == 0:
		return

	if is_showing_category():
		get_child(0).item = back_item

	var item_index = 0
	for i in range(1 if is_showing_category() else 0, nb_children):
		var child: GalleryItemComponent = get_child(i)
		child.item = items[item_index] if item_index < items.size() else null
		item_index += 1


func _add_item_slot(i: int):
	print("adding item container")
	var container: GalleryItemComponent = item_scene.instantiate()
	container.name = "Item_" + str(i)
	add_child(container)
	container.owner = owner
	container.clicked.connect(_on_item_clicked)


func _remove_item_slot(i: int):
	var child = get_child(i)
	remove_child(child)
	child.queue_free()


func _on_item_clicked(item: GalleryItem):
	if item is CategoryItem:
		self.items = item.products
	elif item is ProductItem:
		ticket.add_product(item, 1)
	elif item is BackItem:
		self.items = categories
	else:
		print("Unknow item type clicked: ", item)


func is_showing_category() -> bool:
	return items != categories
